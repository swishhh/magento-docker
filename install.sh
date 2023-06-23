#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

printf "Enter project's name ( ${GREEN}my-test-project, test etc.${NC}): "
read NAME

echo '';

# Defaults
# TODO: varnish versions management
VARNISH_VERSION="6.0"

SERVER_NAME=$NAME".lc"

printf "Server name (${GREEN}empty for ${SERVER_NAME}${NC}): "
read PROVIDED_SERVER_NAME

if [ "$PROVIDED_SERVER_NAME" != "" ] ; then
  SERVER_NAME="$PROVIDED_SERVER_NAME"
fi

NGINX_DIR="./projects/$NAME/nginx";
NGINX_CONF="$NGINX_DIR/nginx.conf"
mkdir -p $NGINX_DIR
cp "./var/sample/nginx.conf" $NGINX_CONF
sed -i '' "s/sample.lc/$SERVER_NAME/" $NGINX_CONF

echo ''

getFullPathToProject () {
  # todo: check specific folder definition as root may contain magento folder with magento root
  printf "Magento installation folder (${GREEN}/var/www/magento${NC}): "
  read PROJECT_ROOT_PATH
  PROJECT_ROOT_PATH=${PROJECT_ROOT_PATH%/}

  if [ -d "$PROJECT_ROOT_PATH" ]; then
    if [ -f "$PROJECT_ROOT_PATH/composer.json" ]; then
      printf "${GREEN}OK${NC} magento installation folder found under ${YELLOW}$PROJECT_ROOT_PATH${NC}\n"
    else
      echo ''
      printf "${RED}Error${NC}: there is not magento installation found under $PROJECT_ROOT_PATH\n"
      printf "Please verify that the path ${YELLOW}$PROJECT_ROOT_PATH${NC} is correct.\n"
      echo ''
      getFullPathToProject
    fi
  else
    printf "Magento installation folder ${RED}not found${NC}: $PROJECT_ROOT_PATH\n"
    getFullPathToProject
  fi
}

getFullPathToProject

echo ''

COMPOSER_FILE="$PROJECT_ROOT_PATH/composer.json"
COMPOSER_FILE_PHP_VERSION=`cat $COMPOSER_FILE | grep '"php"'`
COMPOSER_FILE_PHP_VERSION=${COMPOSER_FILE_PHP_VERSION##*:}
COMPOSER_FILE_PHP_VERSION="$(echo "${COMPOSER_FILE_PHP_VERSION}" | tr -d '[:space:]')"

printf "PHP version (composer.json version is ${YELLOW}$COMPOSER_FILE_PHP_VERSION${NC}): \n"
printf "${GREEN}0${NC}: 8.1\n"
printf "${GREEN}1${NC}: 7.4\n"

read -p "Enter an index of version: " PHP_VERSION

if [ "$PHP_VERSION" == "0" ]; then
  PHP_VERSION="8.1"
else
  PHP_VERSION="7.4"
fi

### VARNISH
VARNISH_DIR="./projects/$NAME/varnish/$VARNISH_VERSION"
VARNISH_FILE="$VARNISH_DIR/default.vcl"
mkdir -p $VARNISH_DIR
touch $VARNISH_FILE

ENV_FILE="./projects/$NAME/.env"

if [ -f "$ENV_FILE" ]; then
    rm $ENV_FILE
fi

touch $ENV_FILE

echo "PROJECT_NAME=$NAME" >> $ENV_FILE
echo "SOURCE_DIRECTORY=$PROJECT_ROOT_PATH" >> $ENV_FILE
echo "NGINX_CONFIG_PATH=$NGINX_CONF" >> $ENV_FILE
echo "SERVER_NAME=$SERVER_NAME" >> $ENV_FILE
echo "DB_DATA_PATH=./projects/$NAME/db/data" >> $ENV_FILE
echo "PHP_VERSION=$PHP_VERSION" >> $ENV_FILE
echo "ELASTIC_DATA_PATH=./projects/$NAME/elasticsearch/data" >> $ENV_FILE
echo "VARNISH_VERSION=$VARNISH_VERSION" >> $ENV_FILE
echo "VARNISH_VCL_FILE=$VARNISH_FILE" >> $ENV_FILE

echo ''

printf "Switch to created environment? (${GREEN}Y/n${NC}): "
read SWITCH

if [ "$SWITCH" == "" ] || [ "$SWITCH" == "Y" ] || [ "$SWITCH" == "y" ] ; then
  echo ''
  /bin/bash ./switch.sh
  echo ''
  printf "Do not forget to update ${YELLOW}/etc/hosts${NC} file with ${YELLOW}127.0.0.1 $SERVER_NAME${NC}\n"
else
  printf "To switch the environment put ${YELLOW}$ENV_FILE${NC} as ${YELLOW}.env${NC} then run ${YELLOW}docker-compose up -d${NC}\n"
fi