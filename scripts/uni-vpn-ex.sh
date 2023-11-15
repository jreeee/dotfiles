#! /bin/bash

ADDR="vpngate.uni-weimar.de"
PASSWD="$(echo "$(sudo cat /etc/wpa_supplicant/wpa_supplicant.conf | grep "eduroam" -A 20 | grep "password" | cut -d\" -f2)")"
TUNNEL="tunnel Uni Weimar"
#USER="$(echo "${"$(sudo cat /etc/wpa_supplicant/wpa_supplicant.conf | grep "eduroam" -A 20 | grep " identity" | cut -d\" -f2)":0:8}")"
USER="vomo5083"

if [ -z "$1" ]; then
	echo "$PASSWD" | sudo openconnect "vpngate.uni-weimar.de" --authgroup "tunnel Uni Weimar" -u "$USER" --passwd-on-stdin &
else
	sudo pkill openconnect
fi

# this is not that smart since
# - you need to authenticate twice
# - the VPN PWD is stored in a var at runtime
# (and requires a eduroam conf similar to mine)

# the --no-dtls option can be used for certain scenarios where the connection would otherwise not work
# try to connect without it fist bc it slows down your connection a bit since it then only uses TCP
