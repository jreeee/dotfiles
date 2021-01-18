#!/bin/bash

# termite theme

theme=$HOME'/.config/termite/theme'$1'.txt'
config=$HOME'/.config/termite/config'

sed --follow-symlinks -i '/\[colors\]/,$d' $config
cat $theme >> $config

killall -USR1 termite

# wallpaper

pic=$HOME'/dotfiles/wallpapers/wall'$1'.png'
sympic=$HOME'/.config/awesome/themes/powerarrow-dark/wall.png'

if [ -e $sympic ]
then
    rm $sympic
fi

ln -s $pic $sympic

echo 'awesome.restart()' | awesome-client
