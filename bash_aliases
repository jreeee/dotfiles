# couple 'o aliases

# shortend
alias rf="rm -rf"
alias mk="makepkg -scfi PKGBUILD"
alias update="sudo pacman -Syu"
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

# dirs
alias w19="cd ~/Study/WS2019/"
alias s20="cd ~/Study/SS2020/"
alias w20="cd ~/Study/WS2020/"

# scripts 'n programs
alias yt="~/.scripts/yt.sh"
alias vpnconn="sudo ~/.scripts/priv-uni-vpn.sh"
alias lck="~/.scripts/lock.sh"
alias discord="discord-canary"
alias playbg="~/.scripts/an-bg.sh"
