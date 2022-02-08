#!/bin/bash

declare -a FOLDERS

GIT="$HOME/git/"

FOLDERS=( "$GIT"* )

for (( i=1; i<${#FOLDERS[@]}; i++ )) do
	cd "${FOLDERS[i]}" || exit 1
	if [ -e ".git" ]; then
		tmp=$(find | grep -o *.patch)
		if [ "$tmp" != "" ];then
			eval "${FOLDERS[i]}/$tmp 1"
		fi
		echo "updating ${FOLDERS[i]:${#GIT}}"
		git pull
		if [ "$tmp" != "" ];then
            eval "${FOLDERS[i]}/$tmp"
        fi
	fi
done
