#!/bin/bash
rm -rf log-*
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
cycle=48
sleeptime=1

check_ceph_iostate()
{
 ceph_dir=/home/simth/$2
 mkdir -p $ceph_dir
 for i in `cat monitor_ip.conf`;
  do

    echo $current_date >> $ceph_dir/log_iostate_$i
    nohup ssh $i  sar -n DEV 2 $1 >> $ceph_dir/log_net_$i &
    nohup ssh $i  iostat  -t -d -x 2 $1 >> $ceph_dir/log_iostate_$i &
    echo ==============================================>>$ceph_dir/log_iostate_$i
  done
}


collect_basic()
{
  rm -rf basicinfo
  echo starttime: $starttime >> basicinfo
  for node in `cat monitor_ip.conf`;do
    echo ============================
    echo $node basicinfo is: >> basicinfo
    ssh $node sh /home/simth/basicinfo.sh >> basicinfo
  done

}


run_vdbench()
{

echo exectime: ${current_date}.tar.gz >> log-${j}/${i}_dir/summary.html
for((j=0;j<${cycle};j++));do
#ssh 192.168.208.231 echo 3 > /proc/sys/vm/drop_caches 
#ssh 192.168.208.232 echo 3 > /proc/sys/vm/drop_caches 
#ssh 192.168.208.233 echo 3 > /proc/sys/vm/drop_caches 
#for((i=1;i<6;i++));do
for i  in `cat run_config`;do
   kill -9 `ps -ef|grep iostat|awk '{print $2}'`
   kill -9 `ps -ef|grep sar|grep DEV| awk '{print $2}'`
   runtime=`cat config/${i}|grep elapse|awk -F "," '{print $4}'|awk -F "=" '{print int($2)/10}'`
   warmup=`cat config/${i}|grep elapse|awk -F "," '{print $7}'|awk -F "=" '{print int($2)/10}'`
   echo warmup is $warmup ================
   runtime=$[runtime + warmup]
   echo runtimeis $runtime ===============
   mkdir -p log-${j}/${i}_dir
   nohup ./iostat_ceph.sh $runtime log-${j}/${i}_dir &

   ./vdbench/vdbench -j -f config/${i} -o log-${j}/${i}_dir
  done
  sleep $sleeptime
 done
tar -zcf ${current_date}.tar.gz config basicinfo log-*
}

collect_basic
run_vdbench
