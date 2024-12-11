#! /bin/bash

USER="jre"
KBDLAYOUT="de"
HOSTNAME="computer"

echo "KEYMAP=$KBDLAYOUT" >> /etc/vconsole.conf
echo "$HOSTNAME" >> /etc/hostname
echo "hostname='$HOSTNAME'" >> /etc/conf.d/hostname

#install basics
pacman -S linux-headers nano curl git base-devel artix-archlinux-support

# todo cp hosts and replace YOURHOSTNAMEHERE with $HOSTNAME
# copy /etc/ over

usermod -a -G audio,video,power,sudo "$USER"
#video,audio,input,power,storage,optical,lp,scanner,dbus,adbusers,uucp,vboxusers,dialout,network
# mirrorlist https://gitea.artixlinux.org/packages/artix-mirrorlist/src/branch/master/mirrorlist
# pacman -Sy archlinux-keyring artix-keyring
# pacman-key --init
# pacman-key --populate archlinux artix

# as user
# "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# chsh -s /usr/bin/zsh
# cp conf and dot over
# git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
# yay and read in the programs list file (add importance as number?)
