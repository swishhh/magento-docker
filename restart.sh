#!/bin/sh

restartDocker() {
  printf "Restart docker? (${GREEN}Y/n${NC}): "
    read INSTALL
    if [ "$INSTALL" == "" ] || [ "$INSTALL" == "Y" ] || [ "$INSTALL" == "y" ] ; then
      docker-compose down
      docker-compose up -d
    fi
}

restartDocker