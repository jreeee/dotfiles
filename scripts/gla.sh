#!/bin/bash

declare -a FOLDERS

GIT="$HOME/git/"

FOLDERS=( "$GIT"* )

for (( i=1; i<${#FOLDERS[@]}; i++ )) do
	cd "${FOLDERS[i]}" || exit 1
	if [ -e ".git" ]; then
		name=$(echo "${FOLDERS[i]}" | rev | cut -d/ -f1 | rev)
		echo "updating $name"
		git pull
	fi
done
