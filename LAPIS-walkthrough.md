# Create a Lapis app

As user deploy:

	mkdir -p /data/lapis-lua
	lapis new

Edit config.moon. Edit postgresql_url and put in the credentials from /data/lapis/shared/config/database.yml

	import config from require "lapis.config"

	config "development", ->
  		lua_code_cache "on"
  		port 8080
  		postgresql_url "postgres://deploy:@127.0.0.1/lapis"

	config "production", ->
  		port 80
  		num_workers 4
  		lua_code_cache "on"
  		postgresql_url "postgres://deploy:@127.0.0.1/lapis"

Edit web.moon. This is our Lua web app. Replace contents with:

```
lapis = require "lapis"

import Model from require "lapis.db.model"
class Games extends Model

lapis.serve class extends lapis.Application
	"/": =>
    	"Welcome to Lapis #{require "lapis.version"}!"

  	[games: "/games/:id"]: =>
    	id = @params.id
    	game = Games\find id
    	if game then
      		game.json
    	else
      		""
```

Edit nginx.conf. Add the database config (upstream database block) and the /query location.
Also edit lua_code_cache - it should use LUA_CODE_CACHE not CODE_CACHE.

```
worker_processes ${{NUM_WORKERS}};
error_log stderr notice;
daemon off;

events {
  worker_connections 1024;
}

http {
  include mime.types;

  upstream database {
    postgres_server ${{pg POSTGRESQL_URL}};
  }

  server {
    listen ${{PORT}};
    lua_code_cache ${{LUA_CODE_CACHE}};

    location / {
      default_type text/html;
      content_by_lua_file "web.lua";
    }

    location /static/ {
      alias static/;
    }

    location /favicon.ico {
      alias static/favicon.ico;
    }

    location = /query {
      internal;
      postgres_pass database;
      postgres_query $echo_request_body;
    }
  }
}
```

We're ready to run! 

But let's create some data in the Rails app first.

Run this on the Rails console:

```
tile_states = [0,1,nil]
board = []
9.times do
  board_row = []
  9.times do
    board_row << tile_states.sample
  end
  board << board_row
end

Game.new(json: board.to_json).save
```

Finally, compile the Moonscript files and run our app:

```
moonc .
lapis server
```

