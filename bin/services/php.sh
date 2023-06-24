source ./bin/env.sh

## $1 - $PROJECT_ROOT_PATH
getPHPVersion() {
  COMPOSER_FILE="$1/composer.json"

  if [ -f $COMPOSER_FILE ]; then
    COMPOSER_FILE_PHP_VERSION=`cat $COMPOSER_FILE | grep '"php"'`
    if [[ -z $COMPOSER_FILE_PHP_VERSION ]]; then
      COMPOSER_FILE_PHP_VERSION="unresolved"
    else
      COMPOSER_FILE_PHP_VERSION=${COMPOSER_FILE_PHP_VERSION##*:}
      COMPOSER_FILE_PHP_VERSION="$(echo "${COMPOSER_FILE_PHP_VERSION}" | tr -d '[:space:]')"
    fi
  else
    COMPOSER_FILE_PHP_VERSION="undefined"
  fi

  printf "PHP version (composer.json version is ${YELLOW}$COMPOSER_FILE_PHP_VERSION${NC}): \n"

  declare -a versions=("7.4" "8.1")
  for i in "${!versions[@]}"
    do
      printf "${GREEN}$i${NC}: ${versions[$i]}\n"
    done

  read -p "Enter an index of version: " PHP_VERSION

  PHP_VERSION=${versions[$PHP_VERSION]}

  if [[ -z $PHP_VERSION ]]; then
    echo ''
    printf "${RED}Error${NC}: incorrect version selected.\n"
    echo ''
    getPHPVersion
  fi
}