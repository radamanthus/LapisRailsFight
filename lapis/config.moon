import config from require "lapis.config"

config "development", ->
  lua_code_cache "on"
  port 8080
  postgresql_url "postgres://rad:@127.0.0.1/lapis-rails_development"


config "production", ->
  port 80
  num_workers 4
  lua_code_cache "on"
  postgresql_url "postgres://rad:@127.0.0.1/lapis-rails_development"
