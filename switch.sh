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
    ENV_FILE="./projects/$PROJECT_NAME/.env"
    cp $ENV_FILE "./.env"
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