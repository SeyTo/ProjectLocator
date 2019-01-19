A=/a
ROOT=$PROJECTROOT/prdins/
ACTUAL=$ROOT/srcs/fe-admin/
# source ~/.config/i3/vars.sh
SESSION_LOC="~/.vim/session/prdins-fe-admin.vim"

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

function openBrowser() {
  chromium
}

function openServer() {
  urxvtc \
    -cd $ACTUAL \
    -e zsh \
    -c 'npm run serve'
}

function openAPIServer() {
  urxvtc \
    -cd $ROOT/srcs/api-common/ \
    -e zsh \
    -c 'npm run dev'
}

function openCLIWindow() {
  urxvtc \
    -title "CLI TESTS" \
    -cd $ACTUAL \
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

openCLIWindow
i3-msg 'move container to workspace 3'

openServer
i3-msg 'move container to workspace 3'

openAPIServer
i3-msg 'move container to workspace 3'

openMongoDB
i3-msg 'move container to workspace 5'

openMongoClient
i3-msg 'move container to workspace 4'

openEditor 
i3-msg 'move container to workspace 2'

openBrowser
i3-msg 'move container to workspace 2'

i3-msg 'workspace 2'
