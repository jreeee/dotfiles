#!/bin/bash

# deprecated as termite is not maintained anymore
#terconf=$HOME'/.config/termite/config'
terconf=$HOME'/.config/alacritty/alacritty.yml'
awesome=$HOME'/.config/awesome/'
awconf=$awesome'rc.lua'
awwp=$awesome'themes/powerarrow-dark/wall.png'
awth=$awesome'themes/powerarrow-dark/theme.lua'
wall=$HOME'/dotfiles/misc/wallpapers/'

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

	theme=$HOME'/dotfiles/config/themes/theme'$1'.txt'

	if [ -e $theme ]; then

		# note: this is very dirty ans setup-specific

		# termite colors

		# sed --follow-symlinks -i '/\[colors\]/,$d' $terconf
		# cat $theme >> $terconf
		# killall -USR1 termite

		# note: this is very dirty ans setup-specific
		# getting the colors from the selected theme

		# get only the hex values

		declare -A cols

		for (( i=0; i<14; i++ ));
		do
			cols[$i]=`awk '/color'$i' / { print $3 }' $theme`
		done

		hex_bg=$(rgbatohex `echo | awk '/^background/' $theme | sed 's/[a-zA-Z=(),]//g'`)
		hex_a=${hex_bg:7:2}

		# if only the fint(??) changing color is too subtle for you, cou can replace the second $hex_bg with $color3$hex_a

		# alacritty colors

		names=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")

		for (( i=0; i<7; i++ ));
		do
			sed -i --follow-symlinks '0,/'${names[$i]}': .*/s//'${names[$i]}': '\'${cols[$i]}\''/' $terconf
			sed -i --follow-symlinks '0,/'${names[$i]}': .*/! {0,/'${names[$i]}': .*/ s/'${names[$i]}': .*/'${names[$i]}': '\'${cols[$((i+7))]}\''/}' $terconf
		done

		# awesomewm theme colors

		# setting the colors in the theme.lua

		sed -i --follow-symlinks 's/^theme.fg_normal .*/theme.fg_normal \t\t\t\t\t\t\t\t= "'${cols[13]}'" -- color13/' $awth
		sed -i --follow-symlinks 's/^theme.fg_focus .*/theme.fg_focus \t\t\t\t\t\t\t\t\t= "'${cols[6]}'" -- color6/' $awth
		sed -i --follow-symlinks 's/^theme.fg_urgent .*/theme.fg_urgent \t\t\t\t\t\t\t\t= "'{$cols[3]}'" -- color3/' $awth
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
	echo '3 args - select everything individually, if you want to leave sth as is'
	echo 'use 0, order: palette theme wallpaper'
	exit 0
fi

echo 'awesome.restart()' | awesome-client
