#! /bin/bash

# set -x

vol=( $(amixer -D pulse get Master | grep "\[on\]" | cut -d" " -f 7) )
vol_l=${vol[0]//[^0-9]/}
vol_r=${vol[1]//[^0-9]/}

if [[ $# == 0 ]]; then
	if [[ $vol_r == 0 ]]; then
		amixer -D pulse sset Master $vol_l%,$vol_l%
	else
		amixer -D pulse sset Master $vol_r%,$vol_r%
	fi
fi


if [[ $1 == l ]]; then
	amixer -D pulse sset Master "0%,$vol_r%"
elif [[ $1 == r ]]; then
	amixer -D pulse sset Master "$vol_l%,0%"
else
	echo "usage: arg r/l to mute that side, nothing to revert back to normal"
fi
