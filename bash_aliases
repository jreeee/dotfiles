# couple 'o aliases

# root stuff (yeah, the first two aren't ideal, ik...)
alias sudo='doas'
alias doas='doas '
alias sudoedit='doas rnano'
alias cdcg="doas doas -C /etc/doas.conf && echo 'OK' || echo 'ERR'"

# shortend 
alias ba="nano ~/.bash_aliases"
alias za="nano ~/.zshrc"
alias rf="rm -rf"
alias mkp="makepkg -scfi PKGBUILD"
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
alias tree="tree --du -h"
alias src="source ~/.zshrc" #"killall -USR1 termite"
alias poweroff="sudo /usr/bin/poweroff"
alias reboot="sudo /usr/bin/reboot"
alias lck="sleep 1 && xtrlock"
alias vcam="sudo modprobe v4l2loopback video_nr=2 card_label=vcam"
alias 2mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg -o '~/Music/%(title)s.%(ext)s'"
alias pdf2jpg="pdftoppm -jpeg -r 300"
alias search="find . -type d -name"
alias gitlg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdu="git clean -fdx"
alias ff="git restore Assets/Fonts/SHPinscher/SHPinscher.asset"
alias tsync="sudo ntpdate -b -u 0.gentoo.pool.ntp.org"

# dirs
alias w19="cd ~/Study/WS2019/"
alias s20="cd ~/Study/SS2020/"
alias w20="cd ~/Study/WS2020/"

SCD="$HOME/.scripts"
# scripts 'n programs
alias rgb2hex='printf "#%02x%02x%02x\n"'
alias yt="$SCD/yt.sh"
alias vpnconn="sudo $SCD/priv-uni-vpn.sh"
alias webs="sudo $SCD/webstorage.sh"
alias tablet-set="$SCD/tablet-conf.sh"
alias anbg="$SCD/an-bg.sh 3> /dev/null"
alias setthm="$SCD/setthm.sh"
alias hsup="$SCD/hsup.sh"
alias genics="~/git/work-eTeach/tools/ics_gen.py"
alias gla="$SCD/gla.sh"
alias chfont="$SCD/chfont.sh"
alias mensa="$SCD/mensa.sh"
# well...
alias nwbg="anbg 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'" #see if you have internet
