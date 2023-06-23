#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SEARCH_DIRECTORY='./projects'

if [ "$(ls -A $SEARCH_DIRECTORY)" ]; then
  CURRENT_PROJECT=`cat ./.env | grep "PROJECT_NAME"`
  CURRENT_PROJECT=${CURRENT_PROJECT##*=}
  declare -a projects
  for entry in "$SEARCH_DIRECTORY"/*
    do
      projects+=(${entry##*/})
    done

  printf "Select a project: \n"
  for i in "${!projects[@]}"
    do
      if [ "$CURRENT_PROJECT" == "${projects[$i]}" ]; then
        IS_SELECTED="(${YELLOW}current${NC})"
      fi
      printf "${GREEN}$i${NC}: ${projects[$i]} ${IS_SELECTED}\n"
      IS_SELECTED=''
    done

  read -p "Enter project's index: " SELECTED_PROJECT_INDEX
  PROJECT_NAME=${projects[$SELECTED_PROJECT_INDEX]}

  echo ''

  if [ "$PROJECT_NAME" == "$CURRENT_PROJECT" ]; then
    printf "Project ${GREEN}$PROJECT_NAME${NC} is already in use.\n"
  else
    VERSION_FILE="./.version"
    ENV_FILE="./.env"
    NEW_ENV_FILE="./projects/$PROJECT_NAME/.env"

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
      printf "${RED}PHP version has been changed${NC} ${YELLOW}restart docker${NC} (manually use the ${YELLOW}restart.sh${NC} script) \n"
    else
      touch $VERSION_FILE
      echo "0" > $VERSION_FILE
    fi

    cp $NEW_ENV_FILE $ENV_FILE
    printf "Environment switched to ${GREEN}$PROJECT_NAME${NC} \n"
    echo ''
    /bin/bash ./restart.sh
  fi

else
  printf "No installed projects found, would you like to install one? (${GREEN}Y/n${NC}): "
  read INSTALL
  if [ "$INSTALL" == "" ] || [ "$INSTALL" == "Y" ] || [ "$INSTALL" == "y" ] ; then
    /bin/bash ./install.sh
  fi
fi