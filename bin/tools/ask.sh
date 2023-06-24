source ./bin/env.sh

ask() {
  if [[ ! -z $2 ]] && [[ ! -z $2 ]]; then
    printf "$1 ($2$3${NC}): "
  else
    printf "$1: "
  fi
  read INPUT
}