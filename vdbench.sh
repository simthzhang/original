#!/bin/bash
rm -rf log* 
filename=rbd_test
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
cycle=1
sleeptime=1


check_ceph_iostate()
{
 ceph_dir=/home/simth/$2
 mkdir -p $ceph_dir
 for i in `cat cluster_ip.conf`;
  do
   
    echo $current_date >> $ceph_dir/log_iostate_$i
    nohup ssh $i  iostat -d -x 2 $1 >> $ceph_dir/log_iostate_$i &
    echo ============================>>$ceph_dir/log_iostate_$i
  done
}

run_vdbench()
{
echo $current_date ==================

for((j=0;j<${cycle};j++));do
for((i=1;i<2;i++));do
   runtime=`cat config/rbd_test1.conf|grep elapse |awk -F "," '{print $4}'|uniq|awk -F "=" '{print $2}'`
   check_ceph_iostate $runtime log${j}/vdbenchcase${i}_dir &
   echo $runtime ==================
   ./vdbench/vdbench -f config/$filename${i}.conf -o log${j}/vdbenchcase${i}_dir
 # for k in "${!vdbench_clientlist[@]}";do
 #  ssh ${vdbench_clientlist[$k]} rm -rf /mnt/sdb/*
 #  ssh ${vdbench_clientlist[$k]} rm -rf /mnt/sdc/*
 #  ssh ${vdbench_clientlist[$k]} rm -rf /mnt/sdd/*
 # done

  done
  sleep $sleeptime
done
tar -zcf ${current_date}.tar.gz config log*
endtime==`date "+%Y_%m_%d_%H_%M_%S"`
echo start time: ${current_date}.tar.gz 
echo end time: $endtime =========================
}
run_vdbench

