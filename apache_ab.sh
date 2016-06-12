#!/bin/bash
totalcycle=100
target_concurrency=100
single_concurrency=10
step_concurrency=10
server_ip=192.168.10.3
array="100M 1G 10G"

function collect_basicinfo()
 {

# collect os info
echo "CPUINFO:"       `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c` >> ./basicinfo_client.log
echo "Total Memory:"  `cat /proc/meminfo |grep "MemTotal:"` >> ./basicinfo_client.log
echo "Brand:" >> ./basicinfo_client.log
dmidecode | grep -A15 "System Information" >> ./basicinfo_client.log
echo "Mac_INFO:"  `ifconfig -a|grep "ether"` >> ./basicinfo_client.log
echo "IP_Address:" `ifconfig |grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.'|awk -F " " '{print $2;print "\n"}'` >> ./basicinfo_client.log
#echo "RELEASE_VERSION:" `cat /etc/redhat-release` >> ./$date_dir/basicinfo_client.log
echo `ethtool -i eth0` >> ./basicinfo_client.log
echo `ethtool -k eth0` >> ./basicinfo_client.log

echo "destination ip is:" $server_ip
echo "destination ip is:" $server_ip >> ./basicinfo_client.log
echo "---------------------------------------------------------" >> ./basicinfo_client.log
begintime=`date +"%Y-%m-%d %H:%M:%S"` >> ./basicinfo_client.log
echo begin time is: $begintime >> ./basicinfo_client.log

echo collect basicinfo_client done

 }

function exec_ab()
{

for((i=1;i<=4;i++));do
date_dir=`date "+%Y_%m_%d_%H_%M_%S"_client`
mkdir ./$date_dir

#for single_array in "1K 10K 100K 1M 10M 100M 1G 10G 100G"
for single_array in $array 
do

while (( $single_concurrency<$target_concurrency ))
	do
	echo "ab -n $totalcycle -c $single_concurrency http://$server_ip:80/$single_array"
	ab -n $totalcycle -c $single_concurrency http://$server_ip:80/$single_array >> ./$date_dir/$single_array.log	
	echo $single_concurrency
	echo $single_array
	((single_concurrency=single_concurrency+step_concurrency)) 
	echo "==============================================="	
	sleep 60
        done
single_concurrency=10
done
echo "log file is:" $date_dir.tar.gz
tar -zcf ./$date_dir.tar.gz ./$date_dir
sleep 120
done
endtime=`date +"%Y-%m-%d %H:%M:%S"`
echo endtime is: $endtime >> ./basicinfo_client.log
beginwithsecond=`date -d  "$begintime" +%s`
endwithsecond=`date -d  "$endtime" +%s`
echo duration is: `expr $endwithsecond - $beginwithsecond` >> ./basicinfo_client.log
}

collect_basicinfo
exec_ab
