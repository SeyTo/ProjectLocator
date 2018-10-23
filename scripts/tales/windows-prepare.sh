#!/bin/zsh
# opens all project of windows for i3 DE.

ROOT=/a/_proj/tales/
source ~/.config/i3/vars.sh

SESSION_LOC="~/.vim/session/jobdart.vim"

function runvimwithsession() {
  urxvtc \
    -cd /a/_proj/tales/srcs/jobdart/src \
    -e zsh \
    -c 'vim --servername IDE --cmd "nmap ZE :mksession! ~/.vim/session/jobdart.vim<CR>" ./App.vue'
}

i3-msg workspace $ws3
urxvtc \
  -cd /a/_proj/tales/srcs/jobdart \
  -e sh \
  -c 'npm run serve'
urxvtc \
  -cd /a/_proj/tales/docs/ \
  -e sh \
  -c 'vim ./dev/August.md';

sleep 1
i3-msg workspace $ws2 
code

echo waiting for ping
count=0
until nmap -p 8080 localhost | grep -q 'open'; do
  echo no ping
  sleep 5
  count=$(($count + 1)) 
  if [[ $count == 15 ]]; then
    echo notify-send "Taking too long for the server to start. I give up."
    exit
  fi  
done

echo workspace 2
i3-msg "workspace $ws2"
echo starting chromium
i3-msg "exec chromium http://localhost:8080;" && notify-send "Server Ready!!"
echo i love you


# workspace $ws4; exec viewnior $ROOT/docs/design/final ;
# until ping -c1 localhost &>/dev/null; do :; done
