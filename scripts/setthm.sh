#!/bin/bash

terconf=$HOME'/.config/termite/config'
awesome=$HOME'/.config/awesome/'
awconf=$awesome'rc.lua'
awwp=$awesome'themes/powerarrow-dark/wall.png'
awth=$awesome'themes/powerarrow-dark/theme.lua'
wall=$HOME'/dotfiles/misc/wallpapers/'


# wallpaper

setbg () {

	pic=$wall'wall'$1'.png'

	if [ -e $pic ]; then
		ln -sf $pic $awwp
	else
		echo 'ERROR: '$pic' does not exist'
		exit 0
	fi
}

# awesome theme

setthm () {

	sed -i 's/local chosen_theme = themes\[.*/local chosen_theme = themes\['$1'\]/' $awconf
}

# palette

setcol () {

	theme=$HOME'/.config/termite/theme'$1'.txt'

	if [ -e $pic ]; then
		
		#termite colors

		sed --follow-symlinks -i '/\[colors\]/,$d' $terconf
		cat $theme >> $terconf
		killall -USR1 termite

		# awesomewm theme colors
		# note: this is very dirty but *should* work
		# getting the colors from the theme that termite utilizes

		color1=`cat $terconf | grep 'color1 ' | awk '{ print $3 }'`
		color3=`cat $terconf | grep color3 | awk '{ print $3 }'`
		color6=`cat $terconf | grep color6 | awk '{ print $3 }'`
		color10=`cat $terconf | grep color10 | awk '{ print $3 }'`
		color13=`cat $terconf | grep color13 | awk '{ print $3 }'`
		color14=`cat $terconf | grep color14 | awk '{ print $3 }'`

		# setting the colors in the theme.lua

		sed -i --follow-symlinks 's/^theme.fg_normal .*/theme.fg_normal \t\t\t\t\t\t\t\t= "'$color13'" -- color13/' $awth
		sed -i --follow-symlinks 's/^theme.fg_focus .*/theme.fg_focus \t\t\t\t\t\t\t\t\t= "'$color6'" -- color6/' $awth
		sed -i --follow-symlinks 's/^theme.fg_urgent .*/theme.fg_urgent \t\t\t\t\t\t\t\t= "'$color3'" -- color3/' $awth
		sed -i --follow-symlinks 's/^theme.border_normal .*/theme.border_normal \t\t\t\t\t\t\t= "'$color10'" -- color10/' $awth
		sed -i --follow-symlinks 's/^theme.border_focus .*/theme.border_focus \t\t\t\t\t\t\t\t= "'$color14'" -- color14/' $awth
		sed -i --follow-symlinks 's/^theme.border_marked .*/theme.border_marked \t\t\t\t\t\t\t= "'$color1'" -- color1/' $awth
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
			setbg $2
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
		setcol $3
	fi
	if [ $2 != "0" ]; then
		setthm $2
	fi
	if [ $3 != "0" ]; then
		setbg $3
	fi
else
	echo 'usage:'; echo '0 args - you can select what to change'
	echo '1 arg: has to be a number, changes all at once'
	echo '3 args - select everything individually, if you want to leave sth as is'
	echo 'use 0, order: palette theme wallpaper'
	exit 0
fi

echo 'awesome.restart()' | awesome-client