#!/bin/bash

# deprecated as termite is not maintained anymore
#terconf=$HOME'/.config/termite/config'
terconf=$HOME'/.config/alacritty/alacritty.yml'
awesome=$HOME'/.config/awesome/'
awconf=$awesome'rc.lua'
awth=$awesome'themes/powerarrow-dark/theme.lua'
wall=$HOME'/dotfiles/config/themes/wallpapers/'
plte=$HOME'/dotfiles/config/themes/palettes/'

#padding for hexadecimal values

hexpad () {
	len=${#1}
	if [ $len -le "1" ]; then
		echo '0'$1
	else
		echo $1
	fi
}

# takes in a string like "123 12 0 0.4"

rgbatohex() {
	bg_alpha=`echo $4' * 255 + 0.5' | bc -l` # normalized
	bg_alpha=${bg_alpha%.*} # to int
	hex_all=`echo | printf '%x\n' $1 $2 $3 $bg_alpha`
	hex_r=$(hexpad `echo $hex_all | cut -d " " -f 1`)
	hex_g=$(hexpad `echo $hex_all | cut -d " " -f 2`)
	hex_b=$(hexpad `echo $hex_all | cut -d " " -f 3`)
	hex_a=$(hexpad `echo $hex_all | cut -d " " -f 4`)
	echo '#'$hex_r$hex_g$hex_b$hex_a
}

# wallpaper

chkbg () {

	#pic=$wall'wall'$1'.png'

	if [ -e $1 ]; then
		setbg $1
	elif [ -e $HOME'/'$1 ]; then
		setbg $HOME'/'$1
	elif [ -e $wall'wall'$1'.png' ];then
		setbg $wall'wall'$1'.png'
	else
		echo 'ERROR: could not find'
		echo $1
		echo $HOME'/'$1
		echo $wall'wall'$1'.png'
		exit 0
	fi
}

setbg () {

	sed -i 's#^feh .*#feh --bg-fill '$1'#' $awesome'fehbg.sh'
	. $awesome'fehbg.sh'
	sed -i --follow-symlinks 's#^theme.wallpaper .*#theme.wallpaper \t\t\t\t\t\t\t\t= "'$1'"#' $awth
}

# awesome theme

setthm () {

	sed -i 's/local chosen_theme = themes\[.*/local chosen_theme = themes\['$1'\]/' $awconf
}

# palette

setcol () {

	theme=$plte'theme'$1'.txt'

	if [ -e $theme ]; then

		# note: this is very dirty and setup-specific

		# termite colors

		# sed --follow-symlinks -i '/\[colors\]/,$d' $terconf
		# cat $theme >> $terconf
		# killall -USR1 termite

		# getting the colors from the selected theme

		# get only the hex values

		declare -A cols

		for (( i=0; i<16; i++ ));
		do
			cols[$i]=`awk '/color'$i' =/ { print $3 }' $theme`
		done

		hex_bg=$(rgbatohex `echo | awk '/^background/' $theme | sed 's/[a-zA-Z=(),]//g'`)
		hex_a=${hex_bg:7:2}
		bg_o=`df -h | awk '/^background / { print $6 }' $theme | sed 's/.$//'`
		cols[16]=`awk '/^cursor / { print $3 }' $theme`
		cols[17]=`awk '/^cursor_foreground / { print $3 }' $theme`

		# if hex_a is to subte/faint for your liking, just replace $hex_bg with ${cols[3]}$hex_a

		# alacritty colors

		names=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")

		for (( i=0; i<8; i++ ));
		do
			sed -i --follow-symlinks '0,/'${names[$i]}': .*/s//'${names[$i]}': '\'${cols[$i]}\''/' $terconf
			sed -i --follow-symlinks '0,/'${names[$i]}': .*/! {0,/'${names[$i]}': .*/ s/'${names[$i]}': .*/'${names[$i]}': '\'${cols[$((i+8))]}\''/}' $terconf
		done

		sed -i --follow-symlinks '0,/cursor:/! {0,/cursor: .*/ s/cursor: .*/cursor: '\'${cols[16]}\''/}' $terconf
		sed -i --follow-symlinks '0,/cursor:/! {0,/text: .*/ s/text: .*/text: '\'${cols[17]}\''/}' $terconf
		sed -i --follow-symlinks 's/^background_opacity: .*/background_opacity: '$bg_o'/' $terconf
		sed -i --follow-symlinks '0,/primary:/! {0,/background: .*/ s/background: .*/background: '\'${hex_bg:0:7}\''/}' $terconf
		sed -i --follow-symlinks '0,/primary:/! {0,/foreground: .*/ s/foreground: .*/foreground: '\'${cols[7]}\''/}' $terconf

		# awesomewm theme colors

		# setting the colors in the theme.lua

		sed -i --follow-symlinks 's/^theme.fg_normal .*/theme.fg_normal \t\t\t\t\t\t\t\t= "'${cols[13]}'" -- color13/' $awth
		sed -i --follow-symlinks 's/^theme.fg_focus .*/theme.fg_focus \t\t\t\t\t\t\t\t\t= "'${cols[6]}'" -- color6/' $awth
		sed -i --follow-symlinks 's/^theme.fg_urgent .*/theme.fg_urgent \t\t\t\t\t\t\t\t= "'${cols[3]}'" -- color3/' $awth
		sed -i --follow-symlinks 's/^theme.bg_normal .*/theme.bg_normal \t\t\t\t\t\t\t\t= "'$hex_bg'" -- termite background when in rgba/' $awth
		sed -i --follow-symlinks 's/^theme.bg_focus .*/theme.bg_focus \t\t\t\t\t\t\t\t\t= "'$hex_bg'" -- color6 with transparency/' $awth
		sed -i --follow-symlinks 's/^theme.bg_urgent .*/theme.bg_urgent \t\t\t\t\t\t\t\t= "'${cols[3]}$hex_a'" -- color3 with transparency/' $awth
		sed -i --follow-symlinks 's/^theme.border_normal .*/theme.border_normal \t\t\t\t\t\t\t= "'${cols[10]}'" -- color10/' $awth
		sed -i --follow-symlinks 's/^theme.border_focus .*/theme.border_focus \t\t\t\t\t\t\t\t= "'${cols[13]}'" -- color14/' $awth
		sed -i --follow-symlinks 's/^theme.border_marked .*/theme.border_marked \t\t\t\t\t\t\t= "'${cols[1]}'" -- color1/' $awth

	else
		echo 'ERROR: '$theme' does not exist'
		exit 0
	fi
}



if [ -z $1 ]; then
	read -p 'change palette, theme or wallpaper? [p/t/w]' input
	case $input in
		[wW]* )
			echo 'available wallpapers are:'; echo `ls -1 $wall`
			read -p 'select by typing in the part between "wall" and ".png"' input
			setbg $input
			;;
		[pP]* )
			echo 'available palettes are:'; echo `ls -1 $HOME/.config/termite/ | sed '1d'`
			read -p 'select by typing in the part between "theme" and ".txt"' input
			setcol $input
			;;
		[tT]* )
			echo 'available themes are:'; echo `awk '/^local themes = {/,/}/' $awconf | sed 's/[",]//g' | sed '1d;$d'`
			read -p 'select by typing in the part between "theme" and ".txt"' input
			setthm $input
			;;
		*)
			echo 'the input does not match the requirement, exiting'
			exit 0
	esac

elif [ $# -eq "2" ]; then
	case $1 in
		[wW]* )
			chkbg $2
			exit 0
			;;
		[pP]* )
			setcol $2
			;;
		[tT]* )
			setthm $2
			;;
		*)
			echo 'usage: arg1=[p/t/w] arg2=integer'
			exit 0
	esac
elif [ $# -eq "3" ]; then
	if [ $1 != "0" ]; then
		setcol $1
	fi
	if [ $2 != "0" ]; then
		setthm $2
	fi
	if [ $3 != "0" ]; then
		setbg $3
	fi
else
	echo 'usage:'; echo '0 args - you can select what to change'
	echo '3 args - select everything individually, if you want to leave sth as is'
	echo 'use 0, order: palette theme wallpaper'
	exit 0
fi

echo 'awesome.restart()' | awesome-client
