#!/bin/bash

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

mkdir -p /usr/local/go/goPath/src/github.com/CodisLabs/codis/codis_dir/$port/ 1>/dev/null 2>&1

echo -e "$DARKBLUE create codis server config ,port : $port $RESET"

cp -fp codis.conf codis_$port.conf
sed -i "s/pidfile \/mnt\/sdc\/codis\/codis.pid/pidfile \/mnt\/sdc\/codis\/$port\/codis_$port.pid/g" codis_$port.conf
sed -i "s/port 6379/port $port/g" codis_$port.conf
sed -i "s/logfile \"\/mnt\/sdc\/codis\/codis.log\"/logfile \"\/mnt\/sdc\/codis\/$port\/codis_$port.log\"/g" codis_$port.conf
sed -i "s/dbfilename dump.rdb/dbfilename dump_$port.rdb/g" codis_$port.conf
sed -i "s/dir \/mnt\/sdc/dir \/mnt\/sdc\/codis\/$port\//g" codis_$port.conf

if [ $is_master = 1 ]; then
sed -i "s/save 900 1/#save 900 1/g" codis_$port.conf
sed -i "s/save 300 10/#save 300 10/g" codis_$port.conf
sed -i "s/save 60 10000/#save 60 10000/g" codis_$port.conf
else
sed -i "s/# slaveof <masterip> <masterport>/slaveof $master_ip $master_port/g" codis_$port.conf
fi
