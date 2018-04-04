#!/bin/zsh

LOC="`dirname \"$0\"`"
declare -a dirs
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


function get_last() {
  if [ -f $LOC/last ]; then
    cat $LOC/last
  else
    echo No last project found
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
  if [ $1 -lt 10 ]; then
    return 0
  fi
  return 1
}

# for i in `seq ${#DIRS[@]}`;

if [ -z $1 ]; then
  show_menu $1
else
  case "$1" in
    # TODO need better argument parsing
    "p") get_last;;
    "a") show_menu ${@};;
    "l") gotolast `get_last` ${@:2};;
    ''|*[0-9]*) if isValidRange $1; then get_project_at ${@:2} ; fi
  esac
fi


