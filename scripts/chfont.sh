#!/bin/bash

declare -r ALACRITTY=$HOME'/.config/alacritty/alacritty.yml'
declare -r THEME=$HOME'/.config/awesome/themes/modern-slant/theme.lua'
declare -a allfonts
declare -a selfonts

_setfont() {
	font=${selfonts[$1]:1}
	echo "setting font to $font"
	sed -i --follow-symlinks 's/^    family: .*/    family: '"$font"'/' "$ALACRITTY"
	sed -i --follow-symlinks 's/^theme.font.*/theme.font\t\t\t\t\t\t\t\t\t\t= \"'"$font"' 9\"/' "$THEME"
	echo 'awesome.restart()' | awesome-client 2> /dev/null
	exit 0
}

if [ $# -eq "0" ]; then
	echo "Error: no font selected"
	exit 1
fi

readarray -t allfonts< <(fc-list | grep "$1" | cut -d: -f2)
len=${#allfonts[@]}

if [ "$len" -eq "0" ]; then
	echo "Error: no font could be found"
	exit 1
elif [ "$len" -eq "1" ]; then
	selfonts+=("${allfonts[0]}")
	_setfont "0"
else
	for (( i=1; i<len; i++ )) do
		same='false'
		for (( j=0; j<${#selfonts[@]}; j++)) do
			if [ "${allfonts[$i]}" == "${selfonts[$j]}" ]; then
				same='true'
			fi
		done
		if [ "$same" != 'true' ]; then
			selfonts+=("${allfonts[$i]}")
		fi
	done
fi

len2=${#selfonts[@]}
if [ "$len2" -eq "1" ]; then
	_setfont "0"
else
	echo "available fonts:"
	for (( i=0; i<len2; i++ )) do
		echo "$i:${selfonts[$i]}"
	done
	read -p "select the number of the font you want to use " input
	if [ "$input" -eq "$input" ] 2> /dev/null && [ "$input" -ge "0" ] && [ "$input" -le "$len2" ]; then
		_setfont "$input"
	else
		echo "Error: wrong input"
		exit 1
	fi
fi
