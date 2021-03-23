#!/bin/bash

# change sys colors

theme=$HOME'/.config/termite/theme'$1'.txt'
config=$HOME'/.config/termite/config'
awesome=$HOME'/.config/awesome/themes/powerarrow-dark/'
awwp=$awesome'wall.png'
awth=$awesome'theme.lua'
pic=$HOME'/dotfiles/wallpapers/wall'$1'.png'

# termite

sed --follow-symlinks -i '/\[colors\]/,$d' $config
cat $theme >> $config

killall -USR1 termite

# wallpaper

if [ -e $awwp ]
then
    rm $awwp
fi

ln -s $pic $awwp

# awesomewm theme colors
# note: this is very dirty but *should* work

# getting the colors from the theme that awesome utilizes

color1=`cat $config | grep 'color1 ' | awk '{ print $3 }'`
color3=`cat $config | grep color3 | awk '{ print $3 }'`
color6=`cat $config | grep color6 | awk '{ print $3 }'`
color10=`cat $config | grep color10 | awk '{ print $3 }'`
color13=`cat $config | grep color13 | awk '{ print $3 }'`
color14=`cat $config | grep color14 | awk '{ print $3 }'`

# setting the colors in the theme.lua

sed -i --follow-symlinks 's/^theme.fg_normal .*/theme.fg_normal \t\t\t\t\t\t\t\t= "'$color13'" -- color13/' $awth
sed -i --follow-symlinks 's/^theme.fg_focus .*/theme.fg_focus \t\t\t\t\t\t\t\t\t= "'$color6'" -- color6/' $awth
sed -i --follow-symlinks 's/^theme.fg_urgent .*/theme.fg_urgent \t\t\t\t\t\t\t\t= "'$color3'" -- color3/' $awth
sed -i --follow-symlinks 's/^theme.border_normal .*/theme.border_normal \t\t\t\t\t\t\t= "'$color10'" -- color10/' $awth
sed -i --follow-symlinks 's/^theme.border_focus .*/theme.border_focus \t\t\t\t\t\t\t\t= "'$color14'" -- color14/' $awth
sed -i --follow-symlinks 's/^theme.border_marked .*/theme.border_marked \t\t\t\t\t\t\t= "'$color1'" -- color1/' $awth

echo 'awesome.restart()' | awesome-client
