# couple 'o aliases

# shortend
alias rf="rm -rf"
alias mk="makepkg -scfi PKGBUILD"
alias update="sudo pacman -Syu && yay -Ys && yay -Sua"
alias get="sudo pacman -S"
alias remove="sudo pacman -Rsnc"
alias untar="tar -zxvf"
alias lm="ls -t -1"
alias lt="ls --human-readable --size -1 -S --classify"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -v"
alias mkd="mkdir -pv"
alias mtusb="sudo mount -o uid=1000,gid=1000 /dev/sda1 ~/usb"
alias rlterm="killall -USR1 termite"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias lck="sleep 1 && xtrlock"
alias vcam="sudo modprobe v4l2loopback video_nr=2 card_label=vcam"
alias 2mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg -o '~/Music/%(title)s.%(ext)s'"
alias pdf2jpg="pdftoppm -jpeg -r 300"

# dirs
alias w19="cd ~/Study/WS2019/"
alias s20="cd ~/Study/SS2020/"
alias w20="cd ~/Study/WS2020/"

# scripts 'n programs
alias rgb2hex='printf "#%02x%02x%02x\n"'
alias yt="~/.scripts/yt.sh"
alias vpnconn="sudo ~/.scripts/priv-uni-vpn.sh"
alias webs="sudo ~/.scripts/webstorage.sh"
alias tablet-set="~/.scripts/tablet-conf.sh"
alias playbg="~/.scripts/an-bg.sh"
alias setthm="~/.scripts/setthm.sh"
