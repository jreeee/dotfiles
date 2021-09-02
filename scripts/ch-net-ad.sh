#! /bin/bash

#stopped=$(rc-status | grep stopped)

wlan_new="wlan0"
lan_new="eth0"
wlan_old="wlo1"
lan_old="eno1"

if [ "$1" == "1" ]; then
	wlan_new="wlo1"
	lan_new="eno1"
	wlan_old="wlan0"
	lan_old="eth0"
fi

sudo rc-service net."$wlan_old" stop
sudo rc-service net."$lan_old" stop
sleep 1
sudo rc-service wpa_supplicant stop
sudo pkill wpa_supplicant
sleep 1
sudo rc-update del net."$wlan_old"
sudo rc-update del net."$lan_old"
sleep 1
sudo rc-update add net."$wlan_new"
sudo rc-update add net."$lan_new"
sleep 1
sudo rc-service net."$wlan_new" start
sudo rc-service net."$lan_new" start
sleep 1
sudo rc-service wpa_supplicant start
