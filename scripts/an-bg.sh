#!/bin/bash

# from https://github.com/CalinLeafshade/dots/blob/master/bin/bin/bg.sh
# I've made some adjustments for my specific setup
# for it to work all videos in one folder need to have the same file extension

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs
declare -a VIDs
declare -a VRHs # video resolution (only height)
declare -r THREADS="8"

_generate() {
  ffmpeg -i "$1" -vf scale=-1:"$2" -g 48 -keyint_min 48 \
         -sc_threshold 0 -row-mt 1 -threads "$THREADS" -speed 2 -tile-columns 4 \
         "$3"
}

_size() {
  VIDs=( "$2"* ) # add all the files in that directory to the array
  len=${#VIDs[@]}

  if [ "$len" -eq "0" ]; then
    echo 'ERROR: no files could be found, exiting'
    exit 1
  fi

  # getting all the files that are videos and storing their height in VRHs
  type=''
  for (( i=0;  i<"$len"; ++i )) do
    res_i=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "${VIDs[i]}")
    if [ "$res_i" -eq "$res_i" ] 2> /dev/null; then
      VRHs+=("$res_i")
      if [ "$type" == '' ]; then
        type=$(echo "${VIDs[i]}" | grep -oP '\..*')
      fi
    else
      VRHs+=("0")
    fi
  done

  if [ "$type" == '' ]; then
    echo 'ERROR: no files could be found, exiting'
    exit 1
  fi

  res=$(echo "$1" | grep -oP 'x\d+') # sth like 1920x1080-..., becomes x1080
  res=${res:1} # 1080

  # trying to find a matching resolution
  index="0"
  abs_diff="$res"
  max_h_i="$res" # used for converting, assuming that the quality is the best due to the size
  for (( i=0;  i<"$len"; ++i )) do
    res_i=${VRHs[i]}
    if [ "$res_i" -gt 0 ]; then
      dif=$(( res - res_i ))
      [ "$res_i" -gt "$max_h_i" ] && max_h_i=$i;
      [ "$dif" -lt "0" ] && dif=${dif#-};
      [ "$dif" -lt "$abs_diff" ] && index=$i && abs_diff="$dif";
    fi
  done

  if [ "$abs_diff" -eq "0" ]; then
    _screen "$1" "${VIDs[$index]}"
  else
    echo 'there doesn'\''t seem to be a video that matches your screen resolution'
    read -p 'generate a new one or use a existing resolution close to it? \[n/E\] ' input

    case "$input" in
      [Nn]* )
        height="${VRHs[$max_h_i]}"
        source="${VIDs[$max_h_i]}"
        if [ "$height" -gt "$res" ]; then
          echo 'upscaling from '"$res"' to '"$height"
        else
          echo 'downscaling from '"$res"' to '"$height"
        fi
        file="$2"'gen-'"$height""$type"
        _generate "$source" "$height" "$file"
        _screen "$1" "$file"
        ;;
       * )
         echo 'using resolution '"${VRHs[$index]}"' for '"$res"
         _screen "$1" "${VIDs[$index]}"
         ;;
    esac
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
    * )
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
