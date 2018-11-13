#!/bin/bash
ceph_dir=/home/simth/ceph_log/
check_ceph_iostate()
{

for ((i=0;i<20;i++))
 do
     current_date=`date "+%Y-%m-%d %H:%M:%S"`  
     for k in sda1 sda2 sda3 sda4 sda5 sdb1 sdb2 sdb3 sdb4 sdb5 sdc1 sdc2 sdc3 sdc4 sdc5
     do  
        echo  echo currenttime: $current_date >> $ceph_dir/diskinfo_$k
        cat /proc/fs/f2fs/$k/disk_info  >> $ceph_dir/diskinfo_$k
       done
    sleep 5
 done
}
check_ceph_iostate 
