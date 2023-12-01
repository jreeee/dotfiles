#! /bin/bash

# if you have a multi user system you might want to put this in
# .cache or .state or similar to keep a bit of privacy

FILE="/tmp/scrshot-blurred.png"
TMP="/tmp/scrshot.png"

if [ -e "$FILE" ]; then
	rm "$FILE"
fi

if [ -e "$TMP" ]; then
    rm "$TMP"
fi

scrot "$TMP"
magick "$TMP" -blur 0x6 "$FILE"

xsecurelock
