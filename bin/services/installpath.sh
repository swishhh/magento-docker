source ./bin/env.sh
source ./bin/tools/yesno.sh
source ./bin/tools/ask.sh

getInstallPath () {
  ask "Magento installation folder" ${GREEN} "/var/www/magento"
  PROJECT_ROOT_PATH=$INPUT

  if [[ ! -d "$PROJECT_ROOT_PATH" ]]; then
    askYesNo "Directory doesn't exist. Would you like to create it?"
    INPUT=$?
    if [ $INPUT -eq 1 ]; then
      mkdir -p $PROJECT_ROOT_PATH
    else
      print "Create a directory manually and re-run the install process after."
    fi;
  fi
}