#! /bin/bash


id_tab=`xsetwacom list | grep 'Tablet Monitor Pad pad' | awk '{print $6}'`
id_stylus=`xsetwacom list | grep 'Tablet Monitor stylus' | awk '{print $5}'`
primary=eDP1
secondary=HDMI1
option='same-as'

#setting up where the monitor is

case $1 in

	1)
		option='right-of'
		;;

	2)
		option='left-of'
		;;

	3)
		option='below'
		;;

	4)
		option='above'
		;;

	-1)
		echo 'args: 1 - right, 2 - left, 3 - below, 4 - above, else - clone'
		;;
esac

#setting the correct area for the stylus

if [ -z $1 ] || [ $1 -ge '0' ]; then
	xrandr --output $secondary --mode 1920x1080 --$option $primary
	xsetwacom set $id_stylus MapToOutput $secondary
fi

#setting up the buttons

xsetwacom set $id_tab Button 1 'key ctrl z'
xsetwacom set $id_tab Button 2 'key ctrl shift z'

#touchpad
#xsetwacom set $id_tab Button 4 key 4
#xsetwacom set $id_tab Button 5 key 5
#xsetwacom set §id_tab Button 6 key 6
#xsetwacom set $id_tab Button 7 key 7

xsetwacom set $id_tab Button 3 'key tab'
xsetwacom set $id_tab Button 8 'key e'
xsetwacom set $id_tab Button 9 'key ctrl s'
