A=/a
ROOT=$PROJECTROOT/prdins/
ACTUAL=$ROOT/srcs/fe-common/
source ~/.config/i3/vars.sh
SESSION_LOC="~/.vim/session/prdins-fe-common.vim"

# TEST
echo $ROOT
echo $A

function openEditor() {
  code
  # urxvtc \
  #   -cd $ACTUAL/src \
  #   -e zsh
  # the following line will open vim but <F*> commands will all be dead. Dont know why.
  # -c 'vim --servername IDE --cmd "nmap ZE :mksession! ~/.vim/session/prdins-fe-common.vim<CR>" index.js'
}

function openServer() {
  urxvtc \
    -cd $ACTUAL \
    -e zsh \
    -c 'npm run serve'
}

function openCLIWindow() {
  urxvtc \
    -title "CLI TESTS" \
    -cd $ACTUAL \
    -e zsh
}

i3-msg workspace $ws3
openServer
openCLIWindow
sleep 1

i3-msg workspace $ws2
openEditor

