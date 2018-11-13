#!/bin/bash

full_fill_dir=/home/simth/iscsi_full_fill
imagesize=450G
number_begin=0
bs=1M
directnumber=1
numberjob=1
iodepth=1024
devicelist=(sdk sdi)
config_file()
{
    rm -rf $full_fill_dir
    mkdir -p $full_fill_dir
    for i in "${!devicelist[@]}";do
        echo "[global]" >> ${full_fill_dir}/test$i
        echo ioengine=libaio  >> ${full_fill_dir}/test$i
        echo rw=write  >> ${full_fill_dir}/test$i
        echo bs=$bs  >> ${full_fill_dir}/test$i
        echo iodepth=$iodepth >> ${full_fill_dir}/test$i
        echo numjobs=$numberjob >> ${full_fill_dir}/test$i
        echo direct=$directnumber >> ${full_fill_dir}/test$i
        echo size=$imagesize >> ${full_fill_dir}/test$i
        echo group_reporting >> ${full_fill_dir}/test$i
        echo \[device$i\] >> ${full_fill_dir}/test$i
        echo filename=/dev/${devicelist[$i]} >> ${full_fill_dir}/test$i
    done
}


run_config()
{
    for j in "${!devicelist[@]}";do
        ./fio-2.14/fio ${full_fill_dir}/test$j
    done
}
config_file
run_config
