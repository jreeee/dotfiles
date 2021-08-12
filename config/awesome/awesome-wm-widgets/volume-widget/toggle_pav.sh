#!/bin/bash
ps cax | grep pavucontrol > /dev/null
if [ $? -eq 0 ]; then
	pkill pavucontrol
else
	pavucontrol
fi
