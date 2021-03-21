#! /bin/bash

id=`xsetwacom list | grep 'Tablet Monitor Pad pad' | awk '{print $6}'`

xsetwacom set $id Button 1 key ctrl z
xsetwacom set $id Button 2 key ctrl shift z

#touchpad
#xsetwacom set $id Button 4 key 4
#xsetwacom set $id Button 5 key 5
#xsetwacom set §id Button 6 key 6
#xsetwacom set $id Button 7 key 7

xsetwacom set $id Button 3 key tab
xsetwacom set $id Button 8 key e
xsetwacom set $id Button 9 key ctrl s
