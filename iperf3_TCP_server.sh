#!/bin/bash
single_thread=1
four_thread=1
eight_thread=1
twenty_four_thread=1
fourty_eight_thread=1
ninty_six_thread=1
sleep_time=1
#rm -rf ./$date_dir/*.log
date_dir=`date "+%Y_%m_%d_%H_%M_%S"_server`
mkdir $date_dir
run_cycle=5 #determine how many cycles we should run
ip_address=172.131.2.2 #destination address
run_time=60 #run time for each cycle

echo Start collect basic info
# collect os info
echo "CPUINFO:"       `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c` >> ./$date_dir/basicinfo_server.log 
echo "Total Memory:"  `cat /proc/meminfo |grep "MemTotal:"` >> ./$date_dir/basicinfo_server.log
echo "Brand:" >> ./$date_dir/basicinfo_server.log
dmidecode | grep -A15 "System Information" >> ./$date_dir/basicinfo_server.log
echo "Mac_INFO:"  `ifconfig -a|grep "ether"` >> ./$date_dir/basicinfo_server.log
echo "IP_Address:" `ifconfig |grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.'|awk -F " " '{print $2;print "\n"}'` >> ./$date_dir/basicinfo_server.log
#echo "RELEASE_VERSION:" `cat /etc/redhat-release` >> ./$date_dir/basicinfo_server.log
echo `ethtool -i eth0` >> ./$date_dir/basicinfo_server.log
echo `ethtool -k eth0` >> ./$date_dir/basicinfo_server.log

echo "logdir is:" $date_dir >> ./$date_dir/basicinfo_server.log
echo "logdir is:" $date_dir 
echo "---------------------------------------------------------" >> ./$date_dir/basicinfo_server.log
echo collect basicinfo_server done
iperf3 -s >> ./$date_dir/basicinfo_server.log
tar -zcf $date_dir ./$date_dir
