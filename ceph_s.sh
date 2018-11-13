#!/bin/bash
ceph_dir=/home/simth/ceph_log
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
check_cephstatus()
{
 echo $current_date >>$ceph_dir/log_ceph
 ceph -s >> $ceph_dir/log_ceph
 ceph osd tree >> $ceph_dir/log_ceph
 echo ==============================================>>$ceph_dir/log_ceph
}

mkdir -p /home/simth
mkdir -p $ceph_dir

check_cephstatus
