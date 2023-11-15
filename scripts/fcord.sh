#! /bin/bash

# thanks for having horrible linux support with your incredibly outdated electron version discord

# NOTE: Discord works again, but this "works" for basically all electron-esque apps

loop() {
	# this is about as horrible as it gets: when deleting pids for the first time new ones spawn
	# it wouldnt work when it was stored in arrays, hence this abomination which takes more time to finish (which i think is whats happening)
	# and thus deletes all instances that discord spawns without having to run the script twice
	# however the function still has to be run twice, there are hopefully better ways to do this
	# but for now i give up
	if [ "$1" == 'k' ]; then
		pid=$(echo $(ps aux | grep firefox | grep https | awk  '{ print $2 }' | awk  '{ print $1 }'))
		[[ $pid == "" ]] && exit 0
		while [[ $pid != "" ]]
		do
			kill -9 $pid
			pid=$(echo $(ps aux | grep firefox | grep https | awk  '{ print $2 }' | awk  '{ print $1 }'))
		done
	else
		#this part is honestly ok
		url=( $(echo $(ps aux | grep firefox | grep https | awk  '{ print $12 }')) )
		for (( i=0; i<${#url[@]}; ++i )) do
			if [ "$1" == 'f' ]; then
				firefox ${url[i]}
			else
				echo ${url[i]}
			fi
		done
	fi
}

if [ -z "$1" ]; then
	loop 'f'
	loop 'k'
	loop 'k'
	exit 0
fi

case $1 in
	p )
		loop ;;
	k )
		loop 'k'
		loop 'k' ;;
	pk | kp)
		loop
		loop 'k'
		loop 'k' ;;
	a )
		echo $(ps aux | grep firefox | grep https) ;;
	* )
		echo "usage:"
		echo "no arg - kill bg pid and open link in ff"
		echo "p - print url(s)"
		echo "k - kill bg pid(s)"
		echo "a - prints more information" ;;
esac
