#!/bin/bash

declare -a FOLDERS

GIT="$HOME/git/"

FOLDERS=( "$GIT"* )

for (( i=1; i<${#FOLDERS[@]}; i++ )) do
	cd "${FOLDERS[i]}" || exit 1
	if [ -e ".git" ]; then
		echo "updating ${FOLDERS[i]:${#GIT}}"
		git pull
	fi
done
