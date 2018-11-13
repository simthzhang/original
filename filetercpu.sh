#!/bin/bash

if [ $# != 1 ] ; then 
    echo "should be 1 arg, the first is input log"
    exit 1
fi
log_file=$1
echo $log_file

list=("162945" "162946" "fn-radoscl" "tp_librbd" "taskfin_librbd")
for s in ${list[@]}; do
    echo "xxxxxx  $s"
    cat $log_file|grep $s > $s.log
    for i in `cat $s.log -v | grep $s |awk '{print $1}' |awk -F "[m]" '{print $NF}' |sort -u`;do
    echo $i;
    cat $s.log|awk '{print $9}' > $s-$i-cpu
    done;
    rm -rf $s.log 
done

