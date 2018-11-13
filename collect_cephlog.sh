#!/bin/sh

ftpserverip=10.110.133.6
host_name=`hostname`
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
PUTFILE=${host_name}_${current_date}.tar.gz
dir_name=/tmp/ceph_log/
coreid="66704"


collect_cephlog()
{

dir_name1="$dir_name/ceph/"
tar -zcf ${dir_name1}/ceph_log_${PUTFILE} /var/log/ceph
tar -zcf ${dir_name1}/message_${PUTFILE} /var/log/message*
tar -zcf ${dir_name1}/ceph_bin_${PUTFILE} /usr/bin/ceph*
}
collect_corelog()
{

dir_name1="$dir_name/ceph/"
tar -zcf ${dir_name1}/core_${PUTFILE} /core*
}

collect_sdslog()
{
dir_name2="$dir_name/ceph/"
tar -zcf ${dir_name2}/storagemgmt_log_${PUTFILE} /var/log/storagemgmt_cron/
tar -zcf ${dir_name2}/sds_log_${PUTFILE} /var/log/sdsagent/ 
}
collect_monitor()
{
dir_name3="$dir_name/ceph/"
tar -zcf ${dir_name3}/monitor_${PUTFILE} /home/simth/ceph_log/

}


rm -rf $dir_name/ceph/
mkdir -p $dir_name
mkdir -p $dir_name/ceph/
collect_cephlog
collect_corelog
collect_sdslog
collect_monitor
