#!/bin/bash

killall conky

bash $HOME/.config/conky/Desktop/conky-pull.sh &
bash $HOME/.config/conky/Desktop/conky-pull-cv.sh &
conky -c $HOME/.config/conky/Desktop/conkyrc-load-pic &
sleep 1
conky -c $HOME/.config/conky/Desktop/conkyrc-sysinfo &
sleep 1
conky -c $HOME/.config/conky/Desktop/conkyrc-table &
sleep 1
conky -c $HOME/.config/conky/Desktop/conkyrc-weather &
sleep 1
conky -c $HOME/.config/conky/Desktop/conkyrc-covid &
sleep 1
#conky -c $HOME/.config/conky/Desktop/conkyrc-anim &
#sleep 1
conky -c $HOME/.config/conky/Desktop/conkyrc-portal &
