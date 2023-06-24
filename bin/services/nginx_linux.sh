source ./bin/env.sh
source ./bin/tools/ask.sh

## $1 - project's name
configureNginx() {
  SERVER_NAME=$1".lc"
  ask "Server name" ${GREEN} "leave empty for ${SERVER_NAME}"
  PROVIDED_SERVER_NAME=$INPUT

  if [[ ! -z $PROVIDED_SERVER_NAME ]]; then
    SERVER_NAME=$PROVIDED_SERVER_NAME
  fi

  NGINX_DIR="./projects/$1/nginx";
  NGINX_CONF="$NGINX_DIR/nginx.conf"
  mkdir -p $NGINX_DIR
  cp "./var/sample/nginx.conf" $NGINX_CONF

  ## linux
  sed -i "s/sample.lc/$SERVER_NAME/" $NGINX_CONF
}