#!/bin/bash
devicelist=(sdb sdc sdd)
timeout=$1
cmds_target=$2
queue_depth=$3

filter()
{
if [ -z "$1" ]; then
    echo "1st argument is empty!"
    echo Sample: ./filterdevice.sh "<timeout> <cmds_max> <queue_depth>"
    exit
fi

if [ -z "$2" ]; then
    echo "2st argument is empty!"
    echo Sample: ./filterdevice.sh "<timeout> <cmds_max> <queue_depth>"
    exit
fi
if [ -z "$3" ]; then
    echo "3st argument is empty!"
    echo Sample: ./filterdevice.sh "<timeout> <cmds_max> <queue_depth>"
    exit
fi



for i in "${!devicelist[@]}";do
  device_number=`ls -l -a  /sys/dev/block/|grep ${devicelist[$i]}|awk -F "/" '{print $7}' ` 
  seg1=`echo $device_number|awk -F "target" '{print $2}'`
  echo $timeout > /sys/class/scsi_disk/${seg1}:1/device/timeout
done
sed -i '172s/^.*cmds_max.*$/node.session.cmds_max\ =\ '"${cmds_target}"'/g' /etc/iscsi/iscsid.conf
sed -i '176s/^.*queue_depth.*$/node.session.queue_depth\ =\ '"${queue_depth}"'/g' /etc/iscsi/iscsid.conf
}

check()
{
for i in "${!devicelist[@]}";do
  device_number=`ls -l -a  /sys/dev/block/|grep ${devicelist[$i]}|awk -F "/" '{print $7}' `
  seg1=`echo $device_number|awk -F "target" '{print $2}'`
  #echo $timeout > /sys/class/scsi_disk/${seg1}:1/device/timeout
  cat   /sys/class/scsi_disk/${seg1}:1/device/timeout
done

}


filter $1 $2 $3
check
cat /etc/iscsi/iscsid.conf|grep  cmds_max\ = 
cat /etc/iscsi/iscsid.conf|grep queue_depth\ =
