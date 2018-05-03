# opens all project of windows for i3 DE.

i3-msg 'workspace 3; exec urxvtc -cd /a/_proj/tales/srcs/tales; exec urxvtc -cd /a/_proj/tales/srcs/tales; workspace 2'
i3-msg 'exec firefox --new-tab localhost:8080;'
