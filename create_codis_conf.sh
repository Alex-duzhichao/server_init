#!/bin/bash
set -v 
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
            echo -e "$RED e.g.: $0 6379 $RESET" 
            exit 1; 
            ;;
        \?) break;; # unknown flag
    esac
done

if [ $# != 1 ] ; then
    echo -e "$RED e.g.: $0 6379 $RESET" 
    exit 1;
fi

port=$1
config_dir=/root/server_init/
codis=/usr/local/go/goPath/src/github.com/CodisLabs/codis/
codis_dir=${codis}codis_dir/${port}/
codis_cfg=${codis_dir}$port.conf
codis_pid=${codis_dir}$port.pid
codis_log=${codis_dir}$port.log
codis_dump=${codis_dir}$port.rdb

echo -e "$DARKBLUE create codis server config ,port : $port $RESET"

mkdir -p ${codis_dir} 1>/dev/null 2>&1
cp -fp ${config_dir}codis.conf ${codis_cfg}

echo ${codis_pid}
echo ${codis_cfg}
sed -i "s#^pidfile#pidfile ${codis_pid}#g" ${codis_cfg}
sed -i "s#^port#port ${port}#g" ${codis_cfg}
sed -i "s#^logfile#logfile ${codis_log}#g" ${codis_cfg}
sed -i "s#^dbfilename#${codis_dump}#g" ${codis_cfg}
sed -i "s#^dir#${codis_dir}#g" ${codis_cfg}
