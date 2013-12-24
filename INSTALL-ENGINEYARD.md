# Installing on Engine Yard

I've tested this on a v4.2 Rails 4 solo environment.

Run everything as root. Setting up OpenResty installs another Nginx server on /usr/local. Lapis is smart enough to search for OpenResty in /usr/local and use it instead of system Nginx.

## Setup LuaRocks, Moonscript, and Lapis

  cd ~
  wget http://luarocks.org/releases/luarocks-2.1.1.tar.gz
  tar xvzf luarocks-2.1.1.tar.gz
  cd luarocks-2.1.1
  ./configure
  make build
  make install
  luarocks install moonscript
  luarocks install --server=http://rocks.moonscript.org/manifests/leafo lapis

## Install LuaJIT
  
  echo "=dev-lang/luajit-2.0.0_beta7 ~amd64" >> /etc/portage/package.keywords/local

  emerge dev-lang/luajit

## Setup OpenResty

  wget http://openresty.org/download/ngx_openresty-1.4.3.9.tar.gz
  tar xvzf ngx_openresty-1.4.3.9.tar.gz
  cd ngx_openresty-1.4.3.9/
  ./configure --with-cc-opt="-I/usr/include" --with-ld-opt="-L/usr/lib" --with-luajit --with-http_postgres_module
  make
  make install


