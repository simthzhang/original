#!/bin/bash

full_fill_dir=/home/simth/full_fill
imagesize=100G
pool_name=rbd
images_tofullfill=6
number_begin=3
bs=1M
directnumber=1
numberjob=1
iodepth=1024


config_file()
{
    rm -rf $full_fill_dir
    mkdir -p $full_fill_dir
    for (( i=$number_begin;i<$images_tofullfill;i++ ));do
        echo "[global]" >> ${full_fill_dir}/test$i
        echo ioengine=rbd  >> ${full_fill_dir}/test$i
        echo clientname=admin  >> ${full_fill_dir}/test$i
        echo pool=$pool_name >> ${full_fill_dir}/test$i
        echo rw=write  >> ${full_fill_dir}/test$i
        echo bs=$bs  >> ${full_fill_dir}/test$i
        echo iodepth=$iodepth >> ${full_fill_dir}/test$i
        echo numjobs=$numberjob >> ${full_fill_dir}/test$i
        echo direct=$directnumber >> ${full_fill_dir}/test$i
        echo size=$imagesize >> ${full_fill_dir}/test$i
        echo group_reporting >> ${full_fill_dir}/test$i
        echo \[rbd_image$i\] >> ${full_fill_dir}/test$i
        echo rbdname=testimage_100GB_$i >> ${full_fill_dir}/test$i
    done
}


run_config()
{
    for (( i=$number_begin;i<$images_tofullfill;i++ ));do
	begintime=`date "+%Y_%m_%d_%H_%M_%S"`
	echo $begintime
        ./fio-2.14/fio ${full_fill_dir}/test$i
	endtime=`date "+%Y_%m_%d_%H_%M_%S"`
	echo $endtime
    done
}
config_file
run_config

