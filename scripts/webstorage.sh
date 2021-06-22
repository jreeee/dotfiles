#! /bin/bash

#CAUTION: THIS SCRIPT IS IN AN EXPERIMENTAL STATE

#small script to automatically connect you to CalDAV drives, set your username and password
#and the address. if you need a vpn to acces the folder, lauch the script with "v" (before that
#set your vpn script and configure the output to match you script). "u" umounts the drive e
#and terminates your connection.
#since the data in here is sensitive i'd recommend that you make it read-write protected for normal users

user='Username'
pwd='Password'
mnt=/path/to/mount/dir/

connect () {

	wdfs https://link/to/the/drive "$mnt" -o username=$user -o password=$pwd

}

if [ -z "$1" ]; then
	connect &
else
	case "$1" in
		[vV]* )
			sudo sh /path/to/your/vpn/script | while read -r line; do

				#checks the output to match "Connected as"

				if echo "$line" | grep -q "Connected as" ; then
					sleep 2
					connect
				fi
			done
			;;
		[uU]* )
			sudo umount "$mnt" && sudo pkill openconnect
			;;
		*)
			echo 'usage: -:connect to calDAV server v:use a vpn u:umount and disconnect'
	esac
fi
