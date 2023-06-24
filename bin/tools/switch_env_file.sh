source ./bin/env.sh

# $1 - project name
switchEnvFile() {
  VERSION_FILE="./.version"
  ENV_FILE="./.env"
  NEW_ENV_FILE="./projects/$1/.env"

  CURRENT_PHP_VERSION=`cat $ENV_FILE | grep "PHP_VERSION="`
  CURRENT_PHP_VERSION=${CURRENT_PHP_VERSION##*=}

  NEW_PHP_VERSION=`cat $NEW_ENV_FILE | grep "PHP_VERSION="`
  NEW_PHP_VERSION=${NEW_PHP_VERSION##*=}

  if [ -f "$VERSION_FILE" ]; then
      rm $VERSION_FILE
  fi

  if [ "$CURRENT_PHP_VERSION" != "$NEW_PHP_VERSION" ]; then
    touch $VERSION_FILE
    echo "1" > $VERSION_FILE
    VERSION_CHANGED=1
  else
    touch $VERSION_FILE
    echo "0" > $VERSION_FILE
    VERSION_CHANGED=0
  fi

  cp $NEW_ENV_FILE $ENV_FILE
}