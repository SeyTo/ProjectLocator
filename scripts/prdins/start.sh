ROOT=$prj/prdins/
source ~/.config/i3/vars.sh
SESSION_LOC="~/.vim/session/prdins-fe-common.vim"

# start editor window
i3-msg workspace $ws2
urxvtc \
  -cd /a/_proj/prdins/srcs/fe-common/src \
  -e zsh \
  -c 'vim --servername IDE --cmd "nmap ZE :mksession! ~/.vim/session/prdins-fe-common.vim<CR>" ./App.vue'

# start server console
i3-msg workspace $ws3
urxvtc \
  -cd /a/_proj/prdins/srcs/fe-common/ \
  -e sh \
  -c 'npm run serve'

