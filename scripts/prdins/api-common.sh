A=/a
ROOT=$PROJECTROOT/prdins/
ACTUAL=$ROOT/srcs/api-common/
EXTRA=$A/js/nodejs/_repo/
source ~/.config/i3/vars.sh
SESSION_LOC="~/.vim/session/prdins-api-common.vim"

# TEST
echo $ROOT
echo $A

function openEditor() {
  urxvtc \
    -cd /a/_proj/prdins/srcs/api-common/src \
    -e zsh
  # the following line will open vim but <F*> commands will all be dead. Dont know why.
  # -c 'vim --servername IDE --cmd "nmap ZE :mksession! ~/.vim/session/prdins-api-common.vim<CR>" index.js'
}

function openServer() {
  urxvtc \
    -cd /a/_proj/prdins/srcs/api-common/ \
    -e zsh \
    -c 'npm run serve'
}

function openCurlTestWindow() {
  urxvtc \
    -title "CURL TEST" \
    -cd $ROOT/srcs/curl \
    -e zsh 
}

function openMongoDB() {
  urxvtc \
    -title "MONGO DAEMON" \
    -e zsh \
    -c 'sudo mongod'
}

function openMongoClient() {
  urxvtc \
    -cd $ROOT/srcs/db \
    -name "MONGO CLIENT" 
}

function openCLIWindow() {
  urxvtc \
    -title "CLI TESTS" \
    -cd $ACTUAL \
    -e zsh
}

function openExtra() {
  if [ -z $EXTRA/api-nodejs ]; then
    echo no project api-nodejs found in $EXTRA
    return
  fi
  echo $EXTRA

  urxvtc \
    -title "SNIPPET" \
    -cd $EXTRA/api-nodejs/src \
    -e zsh
}

i3-msg workspace $ws1
openExtra
sleep 1

i3-msg workspace $ws2
openEditor
sleep 1

i3-msg workspace $ws3
openServer
openCurlTestWindow
openCLIWindow
sleep 1

i3-msg workspace $ws4
openMongoDB
openMongoClient
