#!/bin/bash

log_dir=$1
image_num=$2
config_filename=$3
num=$4
server_list=`cat ./fioserver_list.conf`
step=$image_num

fill_image()
{
    image_start=`expr $num \* $step`
    num=`expr $num + 1`
    image_end=`expr $num \* $step`
    echo $num ===============
    # $image_start $image_end: Different fio server run in different image
    for(( i=$image_start; i<$image_end;i++ ));do
        echo  "["rbd_image${i}"]" >> $log_dir/$config_filename
        echo rbdname=testimage_100GB_$i >> $log_dir/$config_filename
        done
}

fill_image

