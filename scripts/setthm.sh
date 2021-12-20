#!/bin/bash

# deprecated as termite is not maintained and I don't use it anymore
#terconf=$HOME'/.config/termite/config'

declare -r TERCONF=$HOME'/.config/alacritty/alacritty.yml'
declare -r AWESOME=$HOME'/.config/awesome/'
declare -r AWCONF=$AWESOME'rc.lua'
declare -r WALL=$HOME'/dotfiles/config/themes/wallpapers/'
declare -r PLTE=$HOME'/dotfiles/config/themes/palettes/'

# get the theme used by awesome atm by building an array and checking the index in use

# get all the themes, then
if [ -e "$AWCONF" ]; then
	themestr=$(awk 'BEGIN{f=0} /local themes =/{f=1} /\}/{f=0} {if (f) print }' "$AWCONF")
	themelist="${themestr:16}"
	mapfile -t thlist < <( echo "$themelist" | cut --delimiter='"' --fields=2 )
	themenum=$(grep '^local chosen_theme =' "$AWCONF" | tr -d -c 0-9)
	awth=$AWESOME'themes/'"${thlist[$themenum]}"'/theme.lua'
else
	echo "ERROR: your rc.lua could not be found, aborting"
	exit 1
fi
# HELPER FUNCTIONS:

# padding for hexadecimal values

hexpad () {
	len=${#1}
	if [ "$len" -le "1" ]; then
		echo '0'"$1"
	else
		echo "$1"
	fi
}

# takes in a string like "123 12 0 0.4" and turnns it into rgba

rgbatohex () {

	read -a rgba <<< "$1"													# parsing the argument into an array
	rgba[3]=$(printf "%.0f" "$(echo "${rgba[3]}"' * 255 + 0.5' | bc -l)") 	# 0.x to int btwn 0-255
	for (( i=0; i<4; i++ )) do
		rgba[$i]=$(hexpad "$(printf "%x" "${rgba[$i]}")")					# dec to hex plus padding
	done

	echo '#'"${rgba[0]}""${rgba[1]}""${rgba[2]}""${rgba[3]}"

}

# lists all available themes (in your rc.lua)

lsthm () {

	for (( i=1; i<"${#thlist[@]}"; i++ )) do
		echo "$i"': '"${thlist[$i]}"
	done
}

# WALLPAPER

# checks multiple directries if they contain the background, if so it calls setbg()

chkbg () {

	if [ -e "$WALL"'wall'"$1"'.png' ];then
		setbg "$WALL"'wall'"$1"'.png'
	elif [ -e "$HOME"'/'"$1" ]; then
		setbg "$HOME"'/'"$1"
	elif [ -e "$1" ]; then
		setbg "$1"
	else
		echo 'ERROR: could not find'
		echo "$WALL"'wall'"$1"'.png'
		echo "$HOME"'/'"$1"
		echo "$1"
		exit 0
	fi
}

# updates and executes fehbg, also sets the new bg in the awesome conf

setbg () {

	sed -i 's#^feh .*#feh --bg-fill '"$1"'#' "$AWESOME"'fehbg.sh'
	eval "$AWESOME"'fehbg.sh'
	sed -i --follow-symlinks 's#^theme.wallpaper .*#theme.wallpaper \t\t\t\t\t\t\t\t= "'"$1"'"#' "$awth"
}

# THEME

# checks if the theme exists, if so it calls setthm()

chkthm () {

	thsz="${#thlist[@]}"
	chk=1

	if ! [ "$1" -eq "$1" ] 2> /dev/null
	then
		for (( i=1; i<thsz; ++i )) do
			if [ "$1" == "${thlist[$i]}" ]; then
				chk=0
				setthm "$i"
			fi
		done
		if [ $chk == "1" ]; then
			echo 'Theme '"$1"' could not be found, you can ust use args "t 0" to list all themes'
			exit 0
		fi
	elif [ "$1" -eq "0" ]; then
		lsthm thlist
		exit 0
	elif [ "$1" -ge "$thsz" ] || [ "$1" -lt "0" ]; then
		echo 'Theme '"$1"' could not be found, use args "t 0" to list all themes'
		exit 0
	else
		setthm "$1"
	fi
}

setthm () {

	sed -i 's/local chosen_theme = themes\[.*/local chosen_theme = themes\['"$1"'\]/' "$AWCONF"

}

# palette

# since we also change the colors in the theme we need to restart awesome to apply these changes

setcol () {

	palette=$PLTE'palette'$1'.txt'

	if [ -e "$palette" ]; then

		# note: this is very dirty and setup-specific

		# termite colors

		#sed --follow-symlinks -i '/\[colors\]/,$d' $terconf
		#cat $theme >> $terconf
		#killall -USR1 termite

		# getting the colors from the selected theme

		# get only the hex values

		declare -A cols

		for (( i=0; i<16; i++ ));
		do
			cols[$i]=$(awk '/color'"$i"' =/ { print $3 }' "$palette")
		done

		hex_bg=$(rgbatohex "$(echo | awk '/^background/' "$palette" | sed 's/[a-zA-Z=(),]//g')")
		hex_a=${hex_bg:7:2}
		bg_o=$(df -h | awk '/^background / { print $6 }' "$palette" | sed 's/.$//')
		cols[16]=$(awk '/^cursor / { print $3 }' "$palette")
		cols[17]=$(awk '/^cursor_foreground / { print $3 }' "$palette")

		# if hex_a is to subte/faint for your liking, just replace $hex_bg with ${cols[3]}$hex_a

		# alacritty colors

		names=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")

		for (( i=0; i<8; i++ ));
		do
			sed -i --follow-symlinks '0,/'"${names[$i]}"': .*/s//'"${names[$i]}"': '\'"${cols[$i]}"\''/' "$TERCONF"
			sed -i --follow-symlinks '0,/'"${names[$i]}"': .*/! {0,/'"${names[$i]}"': .*/ s/'"${names[$i]}"': .*/'"${names[$i]}"': '\'"${cols[$((i+8))]}"\''/}' "$TERCONF"
		done

		sed -i --follow-symlinks '0,/cursor:/! {0,/cursor: .*/ s/cursor: .*/cursor: '\'"${cols[16]}"\''/}' "$TERCONF"
		sed -i --follow-symlinks '0,/cursor:/! {0,/text: .*/ s/text: .*/text: '\'"${cols[17]}"\''/}' "$TERCONF"
		sed -i --follow-symlinks 's/^background_opacity: .*/background_opacity: '"$bg_o"'/' "$TERCONF"
		sed -i --follow-symlinks '0,/primary:/! {0,/background: .*/ s/background: .*/background: '\'"${hex_bg:0:7}"\''/}' "$TERCONF"
		sed -i --follow-symlinks '0,/primary:/! {0,/foreground: .*/ s/foreground: .*/foreground: '\'"${cols[7]}"\''/}' "$TERCONF"

		# awesomewm theme colors

		# setting the colors in the theme.lua
		# TODO write a nicer loop
		sed -i --follow-symlinks 's/^theme.fg_normal .*/theme.fg_normal \t\t\t\t\t\t\t\t= "'"${cols[13]}"'" -- color13/' "$awth"
		sed -i --follow-symlinks 's/^theme.fg_focus .*/theme.fg_focus \t\t\t\t\t\t\t\t\t= "'"${cols[6]}"'" -- color6/' "$awth"
		sed -i --follow-symlinks 's/^theme.fg_urgent .*/theme.fg_urgent \t\t\t\t\t\t\t\t= "'"${cols[3]}"'" -- color3/' "$awth"
		sed -i --follow-symlinks 's/^theme.bg_normal .*/theme.bg_normal \t\t\t\t\t\t\t\t= "'"$hex_bg"'" -- termite background when in rgba/' "$awth"
		sed -i --follow-symlinks 's/^theme.bg_focus .*/theme.bg_focus \t\t\t\t\t\t\t\t\t= "'"$hex_bg"'" -- color6 with transparency/' "$awth"
		sed -i --follow-symlinks 's/^theme.bg_urgent .*/theme.bg_urgent \t\t\t\t\t\t\t\t= "'"${cols[3]}""$hex_a"'" -- color3 with transparency/' "$awth"
		sed -i --follow-symlinks 's/^theme.border_normal .*/theme.border_normal \t\t\t\t\t\t\t= "'"${cols[10]}"'" -- color10/' "$awth"
		sed -i --follow-symlinks 's/^theme.border_focus .*/theme.border_focus \t\t\t\t\t\t\t\t= "'"${cols[13]}"'" -- color14/' "$awth"
		sed -i --follow-symlinks 's/^theme.border_marked .*/theme.border_marked \t\t\t\t\t\t\t= "'"${cols[1]}"'" -- color1/' "$awth"

		# calculating the difference in pseudo brightness so that the taskbar looks right for dark and light themes
		lum0=$(echo $(( 16#${cols[7]:1:2} )) " + " $(( 16#${cols[7]:3:2} )) " + " $(( 16#${cols[7]:5:2} )) | bc -l)
		lum1=$(echo $(( 16#${cols[0]:1:2} )) " + " $(( 16#${cols[0]:3:2} )) " + " $(( 16#${cols[0]:5:2} )) | bc -l)
		if [ "$lum0" -gt "$lum1" ]; then
			sed -i --follow-symlinks 's/^theme.taskbar_fg .*/theme.taskbar_fg \t\t\t\t\t\t\t\t= "'"${cols[7]}"'" -- color7/' "$awth"
			sed -i --follow-symlinks 's/^theme.taskbar_bg .*/theme.taskbar_bg \t\t\t\t\t\t\t\t= "'"${cols[0]}"'" -- color0/' "$awth"
		else
			sed -i --follow-symlinks 's/^theme.taskbar_fg .*/theme.taskbar_fg \t\t\t\t\t\t\t\t= "'"${cols[0]}"'" -- color7/' "$awth"
			sed -i --follow-symlinks 's/^theme.taskbar_bg .*/theme.taskbar_bg \t\t\t\t\t\t\t\t= "'"${cols[7]}"'" -- color0/' "$awth"
		fi

	else
		echo 'ERROR: '"$palette"' does not exist'
		exit 0
	fi
}

# with no args

if [ -z "$1" ]; then
	read -p 'change palette, theme or wallpaper? [p/t/w]' input
	case $input in
		[wW]* )
			echo 'available theme wallpapers are:'; ls -1 "$WALL"
			read -p 'select by typing in the part between "wall" and ".png" or enter a path to the image ' input
			chkbg "$input"
			exit 0
			;;
		[pP]* )
			echo 'available palettes are:' "$(ls -1 "$PLTE" | sed '1d')"
			read -p 'select by typing in the part between "theme" and ".txt" ' input
			setcol "$input"
			;;
		[tT]* )
			#echo 'available themes are:'; echo `awk '/^local themes = {/,/}/' $AWCONF | sed 's/[",]//g' | sed '1d;$d'`
			echo 'available themes are:'
			chkthm 0 1
			read -p 'select by typing in the index or the name of the theme ' input
			chkthm "$input"
			;;
		*)
			echo 'the input does not match the requirement, exiting'
			exit 0
	esac

# with two args

elif [ $# -eq "1" ]; then
	setcol "$1"
	chkbg "$1"

elif [ $# -eq "2" ]; then
	case $1 in
		[wW]* )
			chkbg "$2"
			exit 0
			;;
		[pP]* )
			setcol "$2"
			;;
		[tT]* )
			chkthm "$2"
			;;
		*)
			echo 'usage: arg1=[p/t/w] arg2=integer/string'
			exit 0
	esac

# with three args

elif [ $# -eq "3" ]; then
	if [ "$1" != "0" ]; then
		chkthm "$1"
	fi
	if [ "$2" != "0" ]; then
		setcol "$2"
	fi
	if [ "$3" != "0" ]; then
		chkbg "$3"
	fi
else
	echo 'usage:'; echo '0 args - you can select what to change'
	echo '2 args - select what you want to change and what it should be changed into'
	echo '3 args - select everything, order: theme palette wallpaper'
	exit 0
fi

echo 'awesome.restart()' | awesome-client 2> /dev/null
