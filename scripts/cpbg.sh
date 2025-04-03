#! /bin/bash

# if you have a multi user system you might want to put this in
# .cache or .state or similar to keep a bit of privacy

DIMMER="/usr/lib/xsecurelock/dimmer"
FILE="/tmp/scrshot-blurred.png"
SAVER="$HOME/.scripts/saver_feh.sh"

if [ -e "$FILE" ]; then
    rm "$FILE"
fi

sleep 2

validPid="$(echo $(pidof "$DIMMER"))"
if [ "" != "$validPid" ]; then
	scrot "$FILE"
fi

sleep 1

if [[ ${#} -ne "0" ]]; then
	#kill -9 "$validPid"
	XSECURELOCK_SAVER="$SAVER" xsecurelock
fi
