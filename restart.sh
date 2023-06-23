#!/bin/sh

restartDocker() {
  printf "Restart docker? (${GREEN}Y/n${NC}): "
  read RESTART
  if [ "$RESTART" == "" ] || [ "$RESTART" == "Y" ] || [ "$RESTART" == "y" ] ; then
    docker-compose down

    VERSION_FILE="./.version"
    if [ `cat $VERSION_FILE` == "1" ]; then
      docker-compose build php
    fi

    docker-compose up -d
  fi
}

restartDocker