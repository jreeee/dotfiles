#! /bin/bash

# best fadeout results with xset your_timeout to 7 or lower

SET_BG="$HOME/.scripts/cpbg.sh"

if [[ ${#} -eq 0 ]]; then
	eval "$SET_BG" &
else
	eval "$SET_BG 1" &
fi

eval /usr/lib/xsecurelock/dimmer
