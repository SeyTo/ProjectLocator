# opens all project of windows for i3 DE.

i3-msg 'workspace 2; exec urxvtc -cd /a/_proj/tales/srcs/tales/src -e sh -c "vim ./App.vue"'
# i3-msg 'workspace 2; exec code /a/_proj/tales/srcs/tales/src'
# i3-msg 'workspace 3; exec urxvtc -cd /a/_proj/tales/srcs/tales -e sh -c npm start; exec urxvtc -cd /a/_proj/tales/srcs/tales; workspace 2'
i3-msg 'workspace 3; exec urxvtc -cd /a/_proj/tales/srcs/tales; exec urxvtc -cd /a/_proj/tales/srcs/tales; workspace 2'
i3-msg 'exec firefox --new-tab localhost:8080;'
