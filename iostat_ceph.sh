#!/bin/bash
ceph_dir=/home/simth/$2
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
check_ceph_iostate()
{

for i in `cat monitor_ip.conf`;
 do
    echo $current_date >> $ceph_dir/log_iostate_$i
    nohup ssh $i  iostat -t -d -x 10 $1 >> $ceph_dir/log_iostate_$i &
    nohup ssh $i  sar -n DEV 10 $1 >> $ceph_dir/log_net_$i &
    echo ==============================================>>$ceph_dir/log_iostate_$i
 done
}
check_ceph_iostate $1 $2
