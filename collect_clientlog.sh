#!/bin/sh

ftpserverip=10.110.133.6
host_name=`hostname`
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
PUTFILE=${host_name}_${current_date}.tar.gz
dir_name=/tmp/ceph_log
coreid="231783"


collect_monitor()
{
rm -rf $dir_name/bussinesslog/
mkdir -p $dir_name
mkdir $dir_name/bussinesslog/
dir_name="$dir_name/bussinesslog/"
tar -zcf ${dir_name}/bussiness_${PUTFILE} /home/simth/log*

}

collect_monitor
