#! /bin/bash

# set -x

declare -a FOLDERS

GIT="$HOME/git/"
IGNORE="$GIT.ignore"
FOLDERS=( "$GIT"* )

# for repos that should be ignored

if [ -e "$IGNORE" ]; then
	readarray -t IGN < "$IGNORE"
	for i in "${IGN[@]}"; do
		#remove the folders from the array that are being ignored
		echo "- ignoring $i"
		FOLDERS=( "${FOLDERS[@]/"$GIT$i"}" )
	done
fi

for i in "${FOLDERS[@]}"; do
	if [ -e "$i" ] && [ -e "$i/.git" ]; then
		cd "$i" || exit 1
		tmp=$(find . -maxdepth 1 -type f -name "*.patch")
		if [ "$tmp" != "" ];then
			echo "- found $tmp"
			echo "> applying pre-pull patch from $tmp"
			eval "$i/$tmp"
		fi
		echo "> updating ${i:${#GIT}}"
		git pull
		if [ "$tmp" != "" ];then
			echo "> applying post-pull patch from $tmp"
			eval "$i/$tmp 1"
		fi
	fi
done
