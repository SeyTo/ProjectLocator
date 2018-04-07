function usage() {
  printf "Testing Arg\n"
  printf "\n"
  printf "\t-h --help\n"
  printf "\t--environment=$ENVIRONMENT\n"
  printf "\t--db-path=$DB_PATH\n"
  printf "\n"
}

echo starting test

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --environment)
            echo environment
            ;;
        --db-path)
            echo dpath
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

