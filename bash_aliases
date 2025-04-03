# couple 'o aliases

# root stuff (yeah, the first two aren't ideal, ik...)
alias sudo="doas"
alias sudoedit='doas rnano'
alias cdcg="doas doas -C /etc/doas.conf && echo 'OK' || echo 'ERR'"

# shortend 
alias ba="nano ~/.bash_aliases"
alias za="nano ~/.zshrc"
alias rf="rm -rf"
alias mkp="makepkg -scfi PKGBUILD"
alias get="yay -S"
alias remove="sudo pacman -Rsnc"
alias untar="tar -zxvf"
alias lm="ls -t -1"
alias lt="ls --human-readable --size -1 -S --classify"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -v"
alias mgb="mg build && cmake .."
alias mkd="mkdir -pv"
alias tree="tree --du -h"
alias src="source ~/.zshrc" # "killall -USR1 termite"
alias lck="sleep 1 && xtrlock"
alias vcam="sudo modprobe v4l2loopback video_nr=2 card_label=vcam"
alias 2mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg --add-metadata -o '%(title)s.%(ext)s'"
alias pl2mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg --add-metadata -o '%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s'"
alias pdf2jpg="pdftoppm -jpeg -r 300"
alias search="find . -type d -name"
alias gitlg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdu="git clean -fdx"
alias tsync="sudo ntpdate -b -u 0.gentoo.pool.ntp.org" # fixed by adding ntp-openrc but nice to have for reference
alias lss="du -sm * | sort -nr | head -n 15"
alias kvpn="sudo pkill openconnect"
alias tl="task list"
alias ta="task add"
alias td="task done"
alias logout="pkill -u $(whoami)"

# scripts 'n programs
SCD="$HOME/.scripts"

alias ia="$SCD/ia"
alias psp="exec /usr/bin/PPSSPPQt &"
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
alias fcord="$SCD/fcord.sh &> /dev/null"
alias zef="~/git/zef/zef.sh"
alias lock-blur="$SCD/blur.sh"
alias khi="~/git/khinsider/khinsider.py"
alias skuk="python $SCD/dbussin.py"

# bluetooth
bl_in_ear="21:D5:F0:D5:6E:3A"
bl_speaker="94:9F:3F:B1:71:36"

# well...
alias nwbg="anbg 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'" #see if you have internet
