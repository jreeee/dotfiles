#! /bin/bash

# if you have a multi user system you might want to put this in
# .cache or .state or similar to keep a bit of privacy

DIMMER="/usr/lib/xsecurelock/dimmer"
FILE="/tmp/scrshot-blurred.png"

if [ -e "$FILE" ]; then
    rm "$FILE"
fi

sleep 2

validPid="$(echo $(pidof "$DIMMER"))"
if [ "" != "$validPid" ]; then
	scrot "$FILE"
fi

if [[ ${#} -ne "0" ]]; then
	xsecurelock
	kill -9 "$validPid"
fi
