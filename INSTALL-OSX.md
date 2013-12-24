# Installing on OS X

I tested this on Mavericks 10.9.1.

## Install Lua, LuaRocks and Lapis

	brew update
	brew install lua
	brew install luarocks
	brew install pcre
	brew install wget
	
Setup wget on Mavericks: http://crosstown.coolestguidesontheplanet.com/os-x/32-install-and-configure-wget-on-os-x

	luarocks install lua-cjson
	luarocks install moonscript
	luarocks install --server=http://rocks.moonscript.org/manifests/leafo lapis

## Setup OpenResty

	cd ~/Downloads
	wget http://openresty.org/download/ngx_openresty-1.4.3.9.tar.gz
	tar xvzf ngx_openresty-1.4.3.9.tar.gz
	cd ngx_openresty-1.4.3.9/
	./configure --with-cc-opt="-I/usr/local/include" --with-ld-opt="-L/usr/local/lib" --with-luajit --with-http_postgres_module
	make
	sudo make install

