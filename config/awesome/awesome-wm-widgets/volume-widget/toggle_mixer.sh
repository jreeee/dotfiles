#!/bin/bash

if [ -z "$1" ]; then
	exit 1
fi

ps cax | grep "$1" > /dev/null

if [ $? -eq 0 ]; then
	pkill "$1"
else
	"$1"
fi
