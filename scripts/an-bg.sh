#!/bin/bash

# from https://github.com/CalinLeafshade/dots/blob/master/bin/bin/bg.sh
# I've made some adjustments for my specific setup
# except for the file-format you can name the files however you like and also
# put other non-video files there
# make sure that all videos in the folder have different resolutions

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs
declare -a VIDs
declare -a VRHs # video resolution (only height)

_generate() {
  threads=$(nproc --all)
  ffmpeg -i "$1" -vf scale=-1:"$2" -g 48 -keyint_min 48 \
         -sc_threshold 0 -row-mt 1 -threads "$threads" -speed 2 -tile-columns 4 \
         -loglevel 0 -stats "$3"
}

_scale() {
  VIDs=( "$2"* ) # add all the files in that directory to the array
  len=${#VIDs[@]}

  if [ "$len" -eq "0" ]; then
    echo 'ERROR: no files could be found, exiting'
    exit 1
  fi

  # getting all the files that are videos and storing their height in VRHs
  type=''
  for (( i=0; i<"$len"; ++i )) do
    # getting the height of the video files
    res_i=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "${VIDs[i]}" 2> /dev/null)
    if [ "$res_i" -eq "$res_i" ] 2> /dev/null; then
      VRHs+=("$res_i")
      if [ "$type" == '' ]; then
        type=$(echo "${VIDs[i]}" | grep -oP '\..*')
      fi
    else
      VRHs+=("0")
    fi
  done

  # making sure that there is at least one playable file in the directory
  if [ "$type" == '' ]; then
    echo 'ERROR: no files could be found, exiting'
    exit 1
  fi

  # getting dimensions
  res=$(echo "$1" | grep -oP 'x\d+') # sth like 1920x1080-..., becomes x1080
  res=${res:1} # 1080

  # trying to find a matching resolution
  index="0"
  abs_diff="$res"
  max_h_i="0" # used for converting, assuming that the quality is the best due to the resolution
  for (( i=0; i<"$len"; ++i )) do
    res_i=${VRHs[i]}
    if [ "$res_i" -gt 0 ]; then
      dif=$(( res - res_i ))
      [ "$res_i" -gt "$max_h_i" ] && max_h_i=$i;
      [ "$dif" -lt "0" ] && dif=${dif#-};
      [ "$dif" -lt "$abs_diff" ] && index=$i && abs_diff="$dif";
    fi
  done

  # if the difference is zero we have a matching video and can play that
  if [ "$abs_diff" -eq "0" ]; then
    _screen "$1" "${VIDs[$index]}" &>/dev/null 2>&1
  else
    echo 'there doesn'\''t seem to be a video that matches your screen resolution'
    read -p 'generate a new one or use a existing resolution close to it? [y/N] ' input

    case "$input" in
      [Yy]* )
        height="${VRHs[$max_h_i]}"
        source="${VIDs[$max_h_i]}"
        if [ "$res" -gt "$height" ]; then
          echo 'upscaling from '"$height"' to '"$res"
        else
          echo 'downscaling from '"$height"' to '"$res"
        fi

        # a new file will be generated and saved in the video folder
        # naming scheme: gen-<screen_height>.<video_format> i.e. gen-720.webm
        file="$2"'gen-'"$res""$type"
        _generate "$source" "$res" "$file"
        _screen "$1" "$file" &>/dev/null 2>&1
        ;;
       * )
         echo 'using resolution '"${VRHs[$index]}"' for '"$res"
         _screen "$1" "${VIDs[$index]}" &>/dev/null 2>&1
         ;;
    esac
  fi
}

_screen() {
  xwinwrap -ov -ni -b -nf -s -un -g "$1" -- mpv --fs\
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
  if [ -e "$PIDFILE" ]; then
    while read p; do
      # checks if the pid is empty / still belongs to mpv and stops / continues / kills it
      [[ -n "$p" && $(ps -p "$p" -o comm=) == "mpv" ]] && kill -"$1" "$p";
    done < $PIDFILE
  fi
  [ "$1" == "9" ] && echo "" > $PIDFILE;
}

if [ $# -gt "0" ]; then

  case "$1" in
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
        # this would be the case if we used the script via setthm.sh
        if [ $# -gt "1" ]; then
          _scale "$i" "$1"
        else # usual usecase: have a video played on all monitors
          _screen "$i" "$1"
        fi
	  done

	  printf "%s\n" "${PIDs[@]}" > $PIDFILE

      exit 0
  esac
else
  _modify '9'
fi
