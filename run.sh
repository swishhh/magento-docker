source ./bin/env.sh
source ./bin/tools/header.sh
source ./bin/tools/projects_list.sh
source ./bin/tools/switch_env_file.sh

header "Run a project."

if [ "$(ls -A $PROJECTS_DIR)" ]; then
  ## $CURRENT_PROJECT #PROJECTS
  listProjects

  selectProject () {
    printf "Select a project: \n"
    for i in "${!projects[@]}"
      do
        if [ "$CURRENT_PROJECT" == "${projects[$i]}" ]; then
          IS_SELECTED="(${YELLOW}current${NC})"
        fi
        printf "${GREEN}$i${NC}: ${projects[$i]} ${IS_SELECTED}\n"
        IS_SELECTED=''
      done

    echo ''
    read -p "Enter project's index: " SELECTED_PROJECT_INDEX
    PROJECT_NAME=${projects[$SELECTED_PROJECT_INDEX]}

    if [[ -z $PROJECT_NAME ]]; then
      echo''
      printf "${RED}Error:${NC} incorrect value provided.\n"
      echo''
      selectProject
    fi
  }

  selectProject

  ## $VERSION_CHANGED
  switchEnvFile $PROJECT_NAME

  echo ''
  header "Running docker..."
  docker-compose down
  if [ $VERSION_CHANGED -eq 1 ]; then
    docker compose build php
  fi
  docker compose up -d

  echo ''
else
  printf "No installed projects found. Please execute ${YELLOW}install.sh${NC} file to install a new project.\n"
fi
