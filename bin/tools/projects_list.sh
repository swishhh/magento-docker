source ./bin/env.sh

declare -a projects

listProjects() {
  CURRENT_PROJECT=`cat ./.env | grep "PROJECT_NAME"`
  CURRENT_PROJECT=${CURRENT_PROJECT##*=}
  for entry in "$PROJECTS_DIR"/*
    do
      projects+=(${entry##*/})
    done
}