askYesNo() {
  printf "$1 (${GREEN}Y/n${NC}): "
  read INPUT

  if [ "$INPUT" == "" ] || [ "$INPUT" == "Y" ] || [ "$INPUT" == "y" ]; then
    RESULT=1
  else
    RESULT=0
  fi

  return $RESULT
}
