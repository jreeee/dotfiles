#! /bin/bash

declare -r HOSTS='/etc/hosts'
declare -r SOURCE='https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
declare -r NEW_FILE=$HOME'/dotfiles/.stuff/new_hosts'
declare -r OLD_FILE=$HOME'/dotfiles/.stuff/hosts_src'

curl -o "$NEW_FILE" "$SOURCE"

if [ -s "$NEW_FILE" ]; then
	if [ -e "$OLD_FILE" ] && ! cmp -s "$OLD_FILE" "$NEW_FILE"; then
		rm "$OLD_FILE"
	else
		echo 'ERROR: old and new files are identical, skipping'
		exit 1
	fi
	mv "$NEW_FILE" "$OLD_FILE"
else
	echo 'ERROR: '"$SOURCE"' could be downloaded to '"$NEW_FILE"
	exit 1
fi

sudo sed -i '/\# blocked sites/,$d' "$HOSTS"

sudo sed -i '$a # blocked sites' "$HOSTS"

sudo sed -i  '$r'"$OLD_FILE" "$HOSTS"
