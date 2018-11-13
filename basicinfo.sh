#!/bin/bash

hostname_node=`hostname`
collect_basicinfo()
{
date_dir=`date "+%Y_%m_%d_%H_%M_%S"_client`
echo hostname_node $hostname_node > 1
physicalNumber=0
coreNumber=0
logicalNumber=0
HTNumber=0
logicalNumber=$(grep "processor" /proc/cpuinfo|sort -u|wc -l)
physicalNumber=$(grep "physical id" /proc/cpuinfo|sort -u|wc -l)
coreNumber=$(grep "cpu cores" /proc/cpuinfo|uniq|awk -F':' '{print $2}'|xargs)
HTNumber=$((logicalNumber / (physicalNumber * coreNumber)))
echo ""
echo ""
echo "******************************* CPU Information *****************************"
echo "CPUINFO:"       `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c` 
echo "Logical CPU Number  : ${logicalNumber}"
echo "Physical CPU Number : ${physicalNumber}"
echo "CPU Core Number     : ${coreNumber}"
echo "HT Number           : ${HTNumber}"
echo ""
echo ""


echo "**************************** Memory Information *****************************"
cat /proc/meminfo |grep "MemTotal:"|awk '{print $2}'
size_gb=`cat /proc/meminfo |grep "MemTotal"|awk '{print int($2)/1024/1024}'`
echo $size_gb GB
dmidecode |grep -A16 "Memory Device$"|grep Type
echo ""
echo ""


echo "**************************** Brand Information ******************************"
dmidecode | grep -A15 "System Information" 
echo ""
echo ""

#echo "Mac_INFO:"  `ifconfig -a|grep "ether"`
#echo "IP_Address:" `ifconfig |grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.'|awk -F " " '{print $2;print "\n"}'` 
#echo "RELEASE_VERSION:" `cat /etc/redhat-release` >> ./$date_dir/basicinfo_client.log
#echo `ethtool -i eth0` >> ./$date_dir/basicinfo_client.log
#echo `ethtool -k eth0` >> ./$date_dir/basicinfo_client.log
#ip a a
#uname -a  >> ./$date_dir/basicinfo_client.log
#fdisk -l >>./$date_dir/basicinfo_client.log
echo "************************ Ethernet Information ******************************"
lspci |grep Ethernet

echo "**************************** OS Information ********************************"
lsb_release -a

echo "************************ Kernel Information ******************************"
uname -a

echo "************************ Disk Information ******************************"
hdparm -W /dev/sd*
lsblk

echo "************************ Raid Information ******************************"
lspci |grep RAID

rm -rf memoryinfo

echo ===================================================================
}

dmidecode -t memory > ${hostname_node}_basicinfo.log
cat   ${hostname_node}_basicinfo.log|grep Type >> ${hostname_node}_basicinfo.log
lspci -vvv  >> ${hostname_node}_basicinfo.log
cat  ${hostname_node}_basicinfo.log |grep NVM >> ${hostname_node}_basicinfo.log

echo *******************************
collect_basicinfo >> ${hostname_node}_basicinfo.log
