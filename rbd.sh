#!/bin/bash
currenttime=`date "+%Y_%m_%d_%H_%M_%S"`

para=`cat para.conf`
echo ===== $para
find_object_place()
#poolname=kubernetes
#rbdimagename=rbdimage_200MB_0
{
poolname=$1
rbdimagename=$2
table=$3
#echo $para  sssss
#echo poolname is:
#poolname=`echo $para|awk -F ":" '{print $1}'`

#poolname=`cat para.conf|awk -F ":" '{pirnt $1}'`
#rbdimagename=`echo ${para}|awk -F ":" '{pirnt $2}'`
#table=`echo ${para}|awk -F ":" '{pirnt $3}'`

echo poolname rbdimagename talbe is: $poolname $rbdimagename $table
mkdir -p $table

hostname=`hostname`
rm -rf objectname.log
rbd -p $poolname ls|grep $rbdimagename
echo image fingerprint
fingerprint=`rbd info -p $poolname $rbdimagename|grep rbd_data|awk -F "." '{print $2}'`
echo $fingerprint
echo all object info
rados -p $poolname ls |grep $fingerprint|grep -v header > allobject.conf
echo first data object
currentdir=`pwd`
cat allobject.conf |awk -F "." '{print $3}' > objectid.conf
#sed -i 's/_/\\\\u/g' allobject.conf
for j in `cat objectid.conf`
do
cd $currentdir
firstdata=`cat allobject.conf|grep rbd_data|grep $j`
echo pg osd info for first object
pg_osd=`ceph osd map $poolname $firstdata`
echo pg_osd isssssssss $pg_osd
bare=`echo $pg_osd|awk '{print $11}'|awk -F "(" '{print $2}'|awk -F ")" '{print $1}'`
echo bare $bare
path_obj=`find  /Ceph/Data/Osd/  -name ${bare}_head|tail -n 1`
#  /Ceph/Data/Osd/osd-nvme-INTEL_SSDPE2MD020T4_CVFT433600902P0KGN-part9/current/4.828_head
for i in `ls -l ${path_obj}|awk '{print $9}'`
do
  echo $i
  cd ${path_obj}/$i
  echo path: $path_obj
  echo step path is ${path_obj}/$i
  echo "ls -l ${path_obj}/$i|grep $j"
  for k in `ls ${path_obj}/$i`
  do
  cd ${path_obj}/$i/$k
  ls -l|grep $j >> /root/${table}/${hostname}_${poolname}_${rbdimagename}_$currenttime
  objectname=`ls |grep $j`
  if [ "$?" -eq 0 ];then
   echo ${path_obj}/$i >> /root/${table}/${hostname}_${poolname}_${rbdimagename}_$currenttime
   echo ==== $objectname
   md5sum $objectname >> /root/${table}/${hostname}_${poolname}_${rbdimagename}_$currenttime
  echo ${path_obj}/$i
  fi
  cd ..
done
cd ..
done

done
endtime=`date "+%Y_%m_%d_%H_%M_%S"`
}

find_object_place `cat para.conf`

