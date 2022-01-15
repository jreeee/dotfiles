#! /bin/bash

declare -r HOSTS='/etc/hosts'
declare -r SOURCE='https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
declare -r FILE_DIR=$HOME'/dotfiles/.stuff'
declare -r NEW_FILE=$FILE_DIR'/new_hosts'
declare -r OLD_FILE=$FILE_DIR'/hosts_src'
declare -r BACKUP=$FILE_DIR'/hosts.bak'
declare -r TMP=$FILE_DIR'/tmp'

curl -o "$NEW_FILE" "$SOURCE"

if [ -s "$NEW_FILE" ]; then
	if [ -e "$OLD_FILE" ]; then
		if cmp -s "$OLD_FILE" "$NEW_FILE"; then
			echo 'ERROR: old and new files are identical, skipping'
			exit 1
		else
			rm "$OLD_FILE"
		fi
	fi
	mv "$NEW_FILE" "$OLD_FILE"
else
	echo 'ERROR: '"$SOURCE"' could be downloaded to '"$NEW_FILE"
	exit 1
fi

cp -f "$HOSTS" "$BACKUP"
cp -f "$HOSTS" "$TMP"

sed -i '/\# blocked sites/,$d' "$TMP"

sed -i '$a # blocked sites' "$TMP"

sed -i  '$r'"$OLD_FILE" "$TMP"

sudo cp -f "$TMP" "$HOSTS"
