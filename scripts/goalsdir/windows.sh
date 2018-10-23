# opens all project of windows for i3 DE.
#!/bin/zsh

ROOT=/a/_proj/goalsdir/

i3-msg "workspace 2; exec urxvtc -cd $ROOT/srcs/web/src -e sh -c 'vim ./App.vue'"
# i3-msg 'workspace 2; exec code /a/_proj/tales/srcs/tales/src'
# i3-msg 'workspace 3; exec urxvtc -cd /a/_proj/tales/srcs/tales -e sh -c npm start; exec urxvtc -cd /a/_proj/tales/srcs/tales; workspace 2'
# exec urxvtc -cd $ROOT/docs/ -e sh -c 'vim todo.md'; 
# exec viewnior $ROOT/docs/design/final ;
i3-msg "
  workspace 3; 
  exec urxvt -cd $ROOT/srcs/web/ -e sh -c 'npm run serve';
  "
# until ping -c1 localhost &>/dev/null; do :; done
until nmap -p 8080 localhost | grep -q 'open'; do
  echo no ping
  sleep 5
done
i3-msg "exec firefox --new-tab localhost:8080;" && notify-send "LOCALHOST window opened"


