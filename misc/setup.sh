#! /bin/bash

#download via curl/git clone

user="jre"
symlinks="y" #yes no custom

# basics

# usermod -a -G sudo $user
#^ has to be run as root (for obvious reasons)

sudo pacman -S archlinux-keyring artix-keyring doas linux-headers wpa_supplicant xorg xorg-dev xorg-xinit xterm alacritty lua git alsa pulseaudio awesome zsh gdb
sudo usermod -a -G audio $user

cd /home/$user/
git clone https://github.com/jreeee/dotfiles /home/$user/
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -scfi PKGBUILD
cd ..
yay -S lain-git freedesktop picom plymouth plymouth-openrc-plugin awesome-freedesktop-git pavucontrol scrot unclutter

#edited doas conf?

sudo chsh /bin/zsh/







