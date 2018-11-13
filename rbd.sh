#!/bin/bash
rm -rf log* 
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
cycle=5
sleeptime=1
vdbench_clientlist=(192.168.209.221 192.168.209.222 192.168.209.223)
check_ceph_iostate()
{
 ceph_dir=/home/simth/$2
 mkdir -p $ceph_dir
 for i in `cat cluster_ip.conf`;
  do
   
    echo $current_date >> $ceph_dir/log_iostate_$i
    nohup ssh $i  iostat -d -x 2 $1 >> $ceph_dir/log_iostate_$i &
    echo ==============================================>>$ceph_dir/log_iostate_$i
  done
}

run_vdbench()
{
replace_para=`grep -rn elapse config/*.conf|awk -F "," '{print $4}'|uniq`
runtime=`echo $replace_para|awk -F "=" '{print $2}'` 
echo $current_date ==================

for((j=0;j<${cycle};j++));do
for((i=1;i<9;i++));do
   check_ceph_iostate 3600 log${j}/vdbenchcase${i}_dir &
   ./vdbench/vdbench -f config/file_${i} -o log${j}/vdbenchcase${i}_dir
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
echo end time: $endtime ==============================================================
}
run_vdbench

