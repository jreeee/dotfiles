#!/bin/bash

#setting up the files
wthr_test="/tmp/weather_test.tmp"
wthr="/tmp/weather.tmp"

function weather-pull {

	#while loop to get updates
	while true 
	do
	
	#replace weimar with your desired city, leave blank to use your ip location
	#curl "https://wttr.in/?T&F&lang=en" --max-time 4 >> $weather_test
	curl "https://wttr.in/weimar?T&F&lang=en" --max-time 4 -s > $wthr_test
	#curl "https://wttr.in/heidelberg?T&F&lang=en" --max-time 4 -s > $wthr_test
	if [ -s $wthr_test ]; then
		mv $wthr_test $wthr
	fi
	sleep 6000
	done
}

weather-pull
