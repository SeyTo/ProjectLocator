# opens all project of windows for i3 DE.
#!/bin/zsh

ROOT=/a/_proj/tales/

i3-msg "workspace 2; exec urxvtc -cd $ROOT/srcs/tales/src -e sh -c 'vim ./App.vue'"
# i3-msg 'workspace 2; exec code /a/_proj/tales/srcs/tales/src'
# i3-msg 'workspace 3; exec urxvtc -cd /a/_proj/tales/srcs/tales -e sh -c npm start; exec urxvtc -cd /a/_proj/tales/srcs/tales; workspace 2'
i3-msg "
  workspace 3; 
  exec urxvt -cd $ROOT/srcs/tales -e sh -c 'npm run dev';
  split v;
  exec urxvtc -cd $ROOT/srcs/tales/src
  exec urxvtc -cd $ROOT/docs/ -e sh -c 'vim todo.md'; 
  workspace 2"
sleep 10 &&
i3-msg 'exec firefox --new-tab localhost:8080;' && notify-send 'LOCALHOST window opened'


