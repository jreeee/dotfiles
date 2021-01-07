#!/bin/zsh

killall conky

#conky -c $HOME/.config/conky/conkyrc-dark-bspwm &
conky -c $HOME/.conky/Desktop/conkyrc-load-pic &
sleep 1
#conky -c $HOME/.config/conky/conkyrc-dark-bg &
conky -c $HOME/.conky/Desktop/conkyrc-sysinfo &
sleep 1
bash $HOME/.conky/Desktop/conky-pull.sh &
sleep 1
conky -c $HOME/.conky/Desktop/conkyrc-weather &
