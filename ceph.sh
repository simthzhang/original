#!/bin/bash
ceph_dir=/home/simth/ceph_log
ceph_node=(192.168.4.7 192.168.4.8 192.168.4.9)
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
check_cephstatus()
{
 echo $current_date >>$ceph_dir/log_ceph
 ceph -s >> $ceph_dir/log_ceph
 ceph osd tree >> $ceph_dir/log_ceph
 echo ==============================================>>$ceph_dir/log_ceph
}

check_ceph_iostate()
{

 echo $current_date >>$ceph_dir/log_iostate
 for i in "${!ceph_node[@]}";do
        echo ${ceph_node[$i]}        
        ssh ${ceph_node[$i]} iostat -dx 2 1 >> $ceph_dir/log_iostate
 done
 echo ==============================================>>$ceph_dir/log_iostate

}
check_ceph_w()
{
nohup ceph -w  >> $ceph_dir/log_ceph_w &
sleep 60
kill -9 `ps -ef|grep ceph|grep ceph\ -w|grep usr|awk '{print $2}'`
}
mkdir $ceph_dir
check_cephstatus
check_ceph_iostate
check_ceph_w

