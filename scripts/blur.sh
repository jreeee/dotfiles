#! /bin/bash

# best fadeout results with xset your_timeout to 7 or lower

MAX_CYCLES=6
SET_BG="$HOME/.scripts/cpbg.sh"
DIMMER="/usr/lib/xsecurelock/dimmer"
FILE="/tmp/scrshot-blurred.png"
SAVER="/home/jre/.scripts/saver-feh.sh"

if [[ ${#} -eq 0 ]]; then
	eval "$SET_BG" &
else
	eval "$SET_BG 1" &
fi

eval "$DIMMER" &

#dim_pid=$!

#input=""
#i=0
#while [ "$input" == "" ]; do
#	if [ "$i" == "$MAX_CYCLES" ]; then
#		rm "$FILE"
#		scrot "$FILE"
#		xsecurelock
#		exit
#	fi
#	input="$(echo -e "\e[?1003;1015h")" # mouse cursor tracking
#	sleep 1
#	i=$(( $i+1 ))
#	echo "cycle $i, $input"
#done
#
#pkill $dim_pid
