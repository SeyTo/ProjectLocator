#!/bin/zsh

LOC="`dirname \"$0\"`"
declare -a dirs

function usage {
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


# create projects file if not exists
if [ ! -f ./projects ]; then
  touch $LOC/projects
fi

if [ ! -f ./last ]; then
  touch $LOC/last
fi

function get_from_root() {
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

function get_from_config() {
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

function output_to_file_arr() {
  for i in $1
  do
    echo output
    echo $i : $2
    # echo $i >> $2
  done
}


function update_last_project() {
  if [ -z $1 ] | [ -z $2 ]; then 
    return 
  fi
  duplicate=`grep -P "$1=$2" $LOC/projects`
  if [[ $duplicate ]]; then
    return
  fi

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


function store_project() {
  echo $1 > $LOC/last 
}


function show_last() {
  if [ -f $LOC/last ]; then
    cat $LOC/last
  else
    echo No last project found
  fi
}

function getlastprojectpath() {
  # TODO change last directory to contain more info
  if [ -f $LOC/last ]; then
    cat $LOC/last 
  else
    echo ''
  fi
}


function getlastprojectname() {
  local last_path=`getlastprojectpath`
  if [[ $last_path != '' ]]; then
    echo $last_path | sed 's/.*\///'
  else
    echo ''
  fi
}


function gotolast() {
  final=$1
  sec=$2
  # jump to inner directory if there was a second argument
  if [[ $sec != 0 ]]; then
    final=$1/$2
  fi
  if cd $final; then
    store_project $1
    echo $final
  else
    echo changing to $1
    cd $1
    echo inner directory argument was incorrect.
  fi
}


function show_menu() {
  if [[ $1 == 'a' ]]
  then
    get_from_root 
  else
    get_from_config
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
    #  store_project $loc &&
      update_last_project $name $loc
    
    break
  done
}


function get_project_at() {
  file=`sed "$1 q;d" $LOC/projects`
  head=`echo $file | grep -Po ".*=" | sed 's/.$//'`
  loc=`echo $file | grep -Po "\/.*"`
  echo $head : $loc 
  select opt in yes no 
  do
    if [ -z $opt ]; then break; fi
    if [ $opt = 'yes' ]; then
      # TODO: need to add sub directory navigation
      gotolast $loc && 
        # store_project $loc &&
        update_last_project $head $loc
      break
    fi
    break
  done
}


function isValidRange() {
  # TODO get range from the file
  if [ $1 -lt 10 ]; then
    return 0
  fi
  return 1
}

function opentasklist() {
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

# start parsing args
while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
  case $PARAM in
    -h | --help)
      usage
      exit
      ;;
    p)
      show_last
      exit
      ;;
    a)
      show_menu ${@}
      exit
      ;;
    l)
      gotolast `show_last` ${@:2}
      exit
      ;;
    *[0-9]*)
      if isValidRange $1; then get_project_at ${@:2}; fi
      exit
      ;;
    ta)
      if [ -n `task --version` ]; then
        opentasklist `getlastprojectname`
      else
        echo Ps install task using \`sudo pacman install task\`
        exit
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

