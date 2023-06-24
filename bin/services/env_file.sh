source ./bin/env.sh

# $1 - project name
# $2 - project's root path
# $3 - nginx conf file path
# $4 - server name
# $5 - PHP versions
# $6 - varnish versions
# $7 - varnish file
buildEnv() {
  ENV_FILE="./projects/$1/.env"

  if [ -f "$ENV_FILE" ]; then
      rm $ENV_FILE
  fi

  touch $ENV_FILE

  echo "PROJECT_NAME=$1" >> $ENV_FILE
  echo "SOURCE_DIRECTORY=$2" >> $ENV_FILE
  echo "NGINX_CONFIG_PATH=$3" >> $ENV_FILE
  echo "SERVER_NAME=$4" >> $ENV_FILE
  echo "DB_DATA_PATH=./projects/$1/db/data" >> $ENV_FILE
  echo "PHP_VERSION=$5" >> $ENV_FILE
  echo "ELASTIC_DATA_PATH=./projects/$1/elasticsearch/data" >> $ENV_FILE
  echo "VARNISH_VERSION=$6" >> $ENV_FILE
  echo "VARNISH_VCL_FILE=$7" >> $ENV_FILE

  printf "${GREEN}OK${NC} Environment file has been created: ${YELLOW}$ENV_FILE${NC}\n"
}