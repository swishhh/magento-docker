source ./bin/services/nginx_linux.sh
source ./bin/services/installpath.sh
source ./bin/services/varnish.sh
source ./bin/services/env_file.sh
source ./bin/services/php.sh
source ./bin/tools/header.sh

header "Project's name."
printf "Enter project's name ( ${GREEN}my-test-project, test etc.${NC}): "
read NAME

echo '';

## $SERVER_NAME $NGINX_DIR $NGINX_CONF
header "Nginx configuration."
configureNginx $NAME

echo ''

## $PROJECT_ROOT_PATH
header "Magento installation path configuration."
getInstallPath

echo ''

## $PHP_VERSION
header "PHP version configuration."
getPHPVersion $PROJECT_ROOT_PATH

echo ''

## $VARNISH_VERSION
getVarnish

header "Environment file build."
buildEnv $NAME $PROJECT_ROOT_PATH $NGINX_CONF $SERVER_NAME $PHP_VERSION $VARNISH_VERSION $VARNISH_FILE

echo ''