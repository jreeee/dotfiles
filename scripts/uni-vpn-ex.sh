#! /bin/bash

if [ -z $1 ]; then
	echo 'PASSWD' | sudo openconnect HOSTNAME --authgroup 'TUNNEL(GROUP)' -u USER --passwd-on-stdin &
else
	sudo pkill openconnect
fi

# this is not that smart since you expose your password, I'll likely update it someday...
# for the time being if you use it (which you shouldn't tbf) at least make it read-write-
# protected to somewhat protect your password, you'll have to be root to run it anyways

# the --no-dtls option can be used for certain scenarios where the connection would otherwise not work
# try to connect without it fist bc it slows down your connection a bit since it then only uses TCP
