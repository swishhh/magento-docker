source ./bin/env.sh
source ./bin/tools/yesno.sh
source ./bin/tools/header.sh

header "Operation system."

system() {
  printf "Please, select related OS: \n"
  echo ''
  declare -a systems=("MacOS" "Linux")
  for i in "${!systems[@]}"
   do
     printf "${GREEN}$i${NC}: ${systems[$i]}\n"
   done
  echo ''

  read -p "Enter an index: " SYSTEM_INDEX
  SYSTEM=${systems[$SYSTEM_INDEX]}

  if [[ -z $SYSTEM ]]; then
   printf "${RED}Error:${NC} incorrect system input.\n"
   system
  fi

  echo ''
  printf "Selected system is ${GREEN}$SYSTEM${NC}\n"
  echo ''

  askYesNo "Would you like to proceed with ${YELLOW}$SYSTEM${NC} system?"
  PROCEED=$?

  if [ $PROCEED -eq 0 ]; then
    echo ''
    system
  fi

  echo ''

  if [ $SYSTEM == "MacOS" ]; then
    /bin/bash ./bin/macos.sh
  fi

  if [ $SYSTEM == "Linux" ]; then
    /bin/bash ./bin/linux.sh
  fi
}

system