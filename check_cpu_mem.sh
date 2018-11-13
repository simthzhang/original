#!/bin/bash
ceph_dir=/home/simth/ceph_log


check_cpu_mem()
{
for ((i=0;i<10;i++));do
    realtime=`date "+%Y-%m-%d %H:%M:%S"`
    cpu_usage=$(mpstat | awk 'END {print 100-$NF}')
    mem_usage=$(free | grep "Mem" | awk '{printf ("%.1f\n",100-(($4+$6)/$2*100))}')
    echo ${realtime} ${cpu_usage} ${mem_usage} >>$ceph_dir/cpu_mem
    sleep 5
done
}
mkdir -p /home/simth
mkdir -p $ceph_dir
check_cpu_mem
systemctl status ntpd >> $ceph_dir/service
/usr/sbin/crm status >> $ceph_dir/crm_status
systemctl status mariadb >> $ceph_dir/mariadb
