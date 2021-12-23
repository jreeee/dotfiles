#!/bin/bash

# from https://github.com/CalinLeafshade/dots/blob/master/bin/bin/bg.sh
# I've made some adjustments for my specific setup

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs
declare -a VIDs

_size() {
  VIDs=( "$2"* )
  len=${#VIDs[@]}
  if [ "$len" -eq "0" ]; then
    exit 1
  elif [ "$len" -eq "1" ]; then
    _screen "$1" "${VIDs[1]}"
    exit 0
  fi
  res=$(echo "$1" | grep -oP 'x\d+') # sth like 1920x1080-..., becomes x1080
  res=${res:1} # 1080
  num="$2"
  num=${num: -2:1} # number of the video selected (like the themes)
  type=$(find "$2" | grep -oPm1 '\..*') # ending of the first file
  file="$2"'v'"$num"'-'"$res""$type" # full path
  if [ -f "$file" ]; then
    _screen "$1" "$file"
  else
    index="0"
    atindex="$res"
    for (( i=0;  i<"$len"; ++i )) do
      vid=${VIDs[i]}
      name=${vid/$2v/}
      name=${name/#*-/}
      name=${name/%.*/}
      dif=$(( res - name ))
      [ "$dif" -lt "0" ] && dif=${dif#-};
      [ "$dif" -lt "$atindex" ] && index=$i && atindex="$dif";
    done

    _screen "$1" "${VIDs[$index]}"

  fi
}

_screen() {
  xwinwrap -ov -ni -g "$1" -- mpv --fullscreen\
        --no-stop-screensaver \
        --vo=gpu --hwdec=vaapi \
        --loop-file --no-audio --no-osc --no-osd-bar -wid WID --no-input-default-bindings \
        "$2" &
  sleep 0.5
  #the process tree has to be created first, hence the sleep
  PIDs+=("$(pstree -p $! | grep -oP '\-mpv\(\d+'| grep -oP '\d+')")
  # if we only kill xwinwrap mpv will not termiante but rather sleep,
  # so instead we get mpv's id which also kills xwinwrap when killed
}

_modify() {
  while read p; do
    # checks if the pid is empty / still belongs to mpv and stops / continues / kills it
    [[ -n "$p" && $(ps -p "$p" -o comm=) == "mpv" ]] && kill -"$1" "$p";
  done < $PIDFILE
  [[ "$1" -eq "9" ]] && echo "" > $PIDFILE;
}

if [ $# -gt "0" ]; then

  case $1 in
    [k] )
      _modify '9'
      exit 0
      ;;
    [c] )
      _modify 'CONT'
      exit 0
      ;;
    [s] )
      _modify 'STOP'
      exit 0
      ;;
    *)
	  _modify '9'

      sleep 0.5

	  for i in $( xrandr -q | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+')
	  do
        if [ $# -gt "1" ]; then
          _size "$i" "$1"
        else
          _screen "$i" "$1"
        fi
	  done

	  printf "%s\n" "${PIDs[@]}" > $PIDFILE

      exit 0
  esac
else
  _modify '9'
fi
