#!/bin/bash
CUR_DIR=`pwd`
echo "stop ..... "
for pid in $(ps -aux | grep tshark | awk '{print $2}'); do
    echo $pid
    kill -9 $pid
done
for pid in $(ps -aux | grep libpcap | awk '{print $2}'); do
    echo $pid
    kill -9 $pid
done

#echo "start ..."

#cd $CUR_DIR

#nohup sh libpcap.sh  &
echo "done"
