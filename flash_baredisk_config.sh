#!/bin/bash

log_dir=/home/simth/log/
imagesize=1024G
pool_name=rbd
images_tofullfill=1
number_begin=
bs=1M
directnumber=1
numberjob=1
iodepth=1024


config_file()
{
    rm -rf log/flash*
    mkdir -p $log_dir
    number=0
    confignum=0
    number1=0
    for i in `cat ceph_ip.conf`
    do
        echo number is $number
        number=`expr $number \* $step`
        echo "[global]" >> ${log_dir}/flash_disk_${confignum}.config
        echo ioengine=libaio  >> ${log_dir}/flash_disk_${confignum}.config
        echo rw=write  >> ${log_dir}/flash_disk_${confignum}.config
        echo bs=$bs  >> ${log_dir}/flash_disk_${confignum}.config
        echo iodepth=$iodepth >> ${log_dir}/flash_disk_${confignum}.config
        echo numjobs=$numberjob >> ${log_dir}/flash_disk_${confignum}.config
        echo direct=$directnumber >> ${log_dir}/flash_disk_${confignum}.config
        echo size=$imagesize >> ${log_dir}/flash_disk_${confignum}.config
        echo group_reporting >> ${log_dir}/flash_disk_${confignum}.config
           for j in `cat ${i}_disk|awk '{print $1}'`
            do
              disk=${j}
              disk="/dev/${disk}"
              echo \[device${number1}\] >> ${log_dir}/flash_disk_${confignum}.config
              echo filename=${disk} >> ${log_dir}/flash_disk_${confignum}.config
              echo  disk is $disk
              echo number1 is $number1
              number1=$(($number1+1))
     done
        number=$(($number+1))
        confignum=$(($confignum+1))
        echo confignum is $confignum
    done
 
}


run_config()
{
    for (( i=$number_begin;i<$images_tofullfill;i++ ));do
	begintime=`date "+%Y_%m_%d_%H_%M_%S"`
	echo $begintime
        ./fio-2.14/fio ${log_dir}/test$i
	endtime=`date "+%Y_%m_%d_%H_%M_%S"`
	echo $endtime
    done
}

config_file
#run_config

