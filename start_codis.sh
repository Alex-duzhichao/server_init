#!/bin/bash
# set -v 
RED=\\e[1m\\e[31m
DARKRED=\\e[31m
GREEN=\\e[1m\\e[32m
DARKGREEN=\\e[32m
BLUE=\\e[1m\\e[34m
DARKBLUE=\\e[34m
YELLOW=\\e[1m\\e[33m
DARKYELLOW=\\e[33m
MAGENTA=\\e[1m\\e[35m
DARKMAGENTA=\\e[35m
CYAN=\\e[1m\\e[36m
DARKCYAN=\\e[36m
RESET=\\e[m

while getopts hn opt
do
    case "$opt" in
        h)
            echo -e "$RED USAGE: $0 port. e.g.: $0 6379 $RESET"
            exit 1; 
            ;;
        \?) break;; # unknown flag
    esac
done

if [ $# != 1 ] ; then
    echo -e "$RED USAGE: $0 port. e.g.: $0 6379 $RESET"
    exit 1;
fi

port=$1
echo -e "$DARKBLUE starting codis server on port : ${port} ... $RESET"

codis=/usr/local/go/goPath/src/github.com/CodisLabs/codis/
codis_dir=${codis}codis_dir/${port}/
codis_cfg=${codis_dir}${port}.conf
codis_server=${codis}bin/codis-server
${codis_server} $codis_cfg

