#!/bin/bash
 
cvd_test="/tmp/cvd_test.tmp"
cvd="/tmp/cvd.tmp"

function cvd-pull {

	while true 
	do
	curl "https://stadt.weimar.de/aktuell/coronavirus/" --max-time 4 -s > $cvd_test
	
	if [ -s $cvd_test ]; then
		grep +++ $cvd_test | sed 's/.*+++ \(.*\) Diese.*/\1/' > $cvd
	fi
	sleep 6000
	done
}

cvd-pull
