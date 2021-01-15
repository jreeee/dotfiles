#!/bin/bash

theme=$HOME'/.config/termite/theme'$1'.txt'
config=$HOME'/.config/termite/config'

sed --follow-symlinks -i '/\[colors\]/,$d' $config
cat $theme >> $config

killall -USR1 termite
