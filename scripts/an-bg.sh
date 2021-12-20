#!/bin/bash

# from https://github.com/CalinLeafshade/dots/blob/master/bin/bin/bg.sh
# I've made some adjustments for my specific setup

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs

_screen() {
    xwinwrap -ov -ni -g "$1" -- mpv --fullscreen\
        --no-stop-screensaver \
        --vo=gpu --hwdec=vaapi \
        --loop-file --no-audio --no-osc --no-osd-bar -wid WID --no-input-default-bindings \
        "$2" &
	sleep 0.5
	#the process tree has to be created first, hence the sleep
    PIDs+=($(pstree -p $! | grep -oP '\-mpv\(\d+'| grep -oP '\d+'))
	# if we only kill xwinwrap mpv will not termiante but rather sleep,
	# so instead we get mpv's id which also kills xwinwrap when killed
}

_modify() {
  while read p; do
    # checks if the pid still belongs to mpv and stops / continues / kills it
    [[ -n "$p" && $(ps -p "$p" -o comm=) == "mpv" ]] && kill -"$1" "$p";
  done < $PIDFILE
}

# checking if $PIDFILE contains PID(s)

if [ $# -gt "0" ];then

  case $1 in
    [0] )
      _modify 'CONT'
      exit 0
      ;;
    [1] )
      _modify 'STOP'
      exit 0
      ;;
    *)
	  _modify '9'

      sleep 0.5

	  for i in $( xrandr -q | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+')
	  do
        _screen "$i" "$1"
	  done

	  printf "%s\n" "${PIDs[@]}" > $PIDFILE

      exit 0
  esac
else
  _modify '9'
fi
