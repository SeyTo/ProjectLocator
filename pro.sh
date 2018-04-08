#!/bin/zsh

LOC="`dirname \"$0\"`"
# collection of directories, temp collection var
declare -a dirs

function usage {
  # shows usages
  cat<<-EOF
  Locates and changes directories to your projects and does other stuffs relating to them.
  usage: ProLo(ProjectLocator) [l [dirs]] [a] [0-9]
    [no args]     show last 10 projects.
    l             goto last project you selected.
    l dirs        goto last project's sub directory.
    a             show all project directories.
    0-9           goto one of the project (if you know its current project id)
    -h            display help
EOF
  return;
}


# create projects file at script location
if [ ! -f ./projects ]; then
  touch $LOC/projects
fi

if [ ! -f ./last ]; then
  touch $LOC/last
fi

function getfromroot() {
  # get all files at ROOT var
  source $LOC/config
  dirs=()
  LS_DIRS=`ls $ROOT`
  CNT=1
  for dir in `ls $ROOT` 
  do
    dirs[$CNT]="/$dir"
    # echo $dir
    # echo ${dirs[$CNT]}
    CNT=`expr $CNT + 1`
  done
}


function getfromconfig() {
  # get all project directories from ./projects
  # and read their path
  dirs=()
  CNT=1
  while read -r line
  do
    head=`echo $line | grep -Po ".*=" | sed 's/.$//'`
    # tail=`echo $line | grep -Po "\/.*"`
    dirs[$CNT]=`printf "%s" $head`
    CNT=`expr $CNT + 1`
  done < $LOC/projects
}


function outputtofilearray() {
  # deprecated
  for i in $1
  do
    echo output
    echo $i : $2
    # echo $i >> $2
  done
}


function updatelastproject() {
  # appends last selected project to ./projects
  # shifts the project from bottom up
  # pops the older projects
  if [ -z $1 ] | [ -z $2 ]; then 
    return 
  fi
  duplicate=`grep -P "$1=$2" $LOC/projects`
  if [[ $duplicate ]]; then
    return
  fi

  # append string to ./projects
  len=(`wc -l $LOC/projects`)
  if [ $len[1] -gt 10 ]; then
    temp=(`tail -n 9 $LOC/projects`)
    truncate -s 0 $LOC/projects
    for i in $temp
    do
      echo $i >> $LOC/projects
    done
  fi
  echo $1=$2 >> $LOC/projects
}


function storeproject() {
  # save the last project location to ./last
  echo $1 > $LOC/last 
}


function getlastprojectpath() {
  # get last project's path
  # TODO change last directory to contain more info
  if [ -f $LOC/last ]; then
    cat $LOC/last 
  else
    echo ''
  fi
}


function getlastprojectname() {
  # get last project's name from actual path format.
  last_path=`getlastprojectpath`

  if [[ $last_path != '' ]]; then
    echo $last_path | sed 's/.*\///'
  else
    echo ''
  fi
}


function gotolast() {
  # change directory to latest project.
  final=$1
  sec=$2
  # jump to inner directory if there was a second argument
  if [[ $sec != 0 ]]; then
    final=$1/$2
  fi
  if cd $final; then
    storeproject $1
    echo cd to: $final
  else
    echo could find here
    sleep 1
    echo cd to: $1
    cd $1
    echo inner directory argument was incorrect.
  fi
}


function showmenu() {
  # show list of all directories in $ROOT dir
  if [[ $1 == 'a' ]]
  then
    getfromroot 
  else
    getfromconfig
  fi

  # select a project
  PS3='index? '
  select opt in "${dirs[@]}"
  do
    # get the option out of the string, todo: volatile
    if [ -z $opt ]; then
      break
    fi
    if [[ $1 == 'a' ]]
    then
      loc=`echo $opt | grep -Po "\/.*"`
      name=${opt:1}
      loc="$ROOT$loc"
    else
      name=$opt
      loc=`grep -P "^$opt" $LOC/projects | grep -Po "\/.*"`
    fi
    # loc=`sed -e "$opt q;d" $LOC/projects | grep -Po "\/.*"`
    gotolast $loc ${@:2} &&
    # cd $loc &&
    #  storeproject $loc &&
      updatelastproject $name $loc
    
    break
  done
}


function getprojectat() {
  # gets project at set location (from ./project)
  file=`sed "$1 q;d" $LOC/projects`
  head=`echo $file | grep -Po ".*=" | sed 's/.$//'`
  loc=`echo $file | grep -Po "\/.*"`
  echo $head : $loc 
  # select yes no before confirming cd
  select opt in yes no 
  do
    if [ -z $opt ]; then break; fi
    if [ $opt = 'yes' ]; then
      # TODO: need to add sub directory navigation
      gotolast $loc && 
        # storeproject $loc &&
        updatelastproject $head $loc
      break
    fi
    break
  done
}


function isvalidrange() {
  # check if given number lies within range of ./project 's list
  # TODO get range from the file
  if [ $1 -lt 10 ]; then
    return 0
  fi
  return 1
}


function opentasklist() {
  # opens task list for the lastest project
  # TODO get task list for project at given number
  last_project=`getlastprojectname`
  if [ -z "$last_project" ]; then
    echo no last project found. Ps Open a project first. 
  else
    echo lastest project: $last_project
    echo task list for $last_project
    task project:$last_project
  fi
}

# for i in `seq ${#DIRS[@]}`;

# START

# start parsing args
if [ "$1" = "" ]; then
  showmenu
  return
fi

while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
  case $PARAM in
    -h | --help)
      usage
      ;;
    p)
      getlastprojectname
      ;;
    a)
      showmenu ${@}
      ;;
    l)
      gotolast `getlastprojectpath` ${@:2}
      # FIXME: hectic exit, removing return will cause exit,??no idea why
      return
      ;;
    *[0-9]*)
      if isvalidrange $1; then getprojectat ${@:2}; fi
      ;;
    ta)
      if [ -n `task --version` ]; then
        opentasklist `getlastprojectname`
      else
        echo Ps install task using \`sudo pacman install task\`
      fi
      ;;
    *)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
  esac
  shift
done

