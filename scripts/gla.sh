#!/bin/bash

declare -a FOLDERS

GIT="$HOME/git/"

FOLDERS=( "$GIT"* )

cd "$GIT"

for (( i=1; i<${#FOLDERS[@]}; i++ )) do
	cd "${FOLDERS[i]}"
	if [ -e ".git" ]; then
		echo "updating ${FOLDERS[i]}"
		git pull
	fi
done
