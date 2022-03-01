#!/bin/bash

declare -a FOLDERS

GIT="$HOME/git/"
IGNORE="$GIT.ignore"

FOLDERS=( "$GIT"* )

# for repos that should be ignored

if [ -e "$IGNORE" ]; then
	readarray -t IGN < "$IGNORE"
	for i in "${IGN[@]}"; do
		#remove the folders from the array that are being ignored
		FOLDERS=( "${FOLDERS[@]/"$GIT$i"}" )
		echo "- ignoring $i"
	done
fi

for i in "${FOLDERS[@]}"; do
	cd "$i" || exit 1
	if [ -e ".git" ]; then
		tmp=$(find . | grep ".patch$")
		if [ "$tmp" != "" ];then
			echo "- found $tmp"
			echo "> applying pre-pull patch from $tmp"
			eval "$i/$tmp 1"
		fi
		echo "> updating ${i:${#GIT}}"
		git pull
		if [ "$tmp" != "" ];then
			echo "> applying post-pull patch from $tmp"
            eval "$i/$tmp"
        fi
	fi
done
