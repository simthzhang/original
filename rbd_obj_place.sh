#!/bin/bash
poolname=$1
rbdimagename=$2
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
for j in `cat objectid.conf`
do
cd $currentdir
firstdata=`cat allobject.conf|grep rbd_data|grep $j`
#echo pg osd info for first object            
pg_osd=`ceph osd map $poolname $firstdata`
#echo pg_osd $pg_osd
bare=`echo $pg_osd|awk '{print $11}'|awk -F "(" '{print $2}'|awk -F ")" '{print $1}'`
#echo bare $bare
path_obj=`find  /Ceph/Data/Osd/  -name ${bare}_head`
#echo path: $path_obj
#  /Ceph/Data/Osd/osd-nvme-INTEL_SSDPE2MD020T4_CVFT433600902P0KGN-part9/current/4.828_head
for i in `ls -l ${path_obj}|awk '{print $9}'` 
do 
  #echo $i
  cd ${path_obj}/$i
  objectname=`ls |grep $j`
  ls -l|grep $j >> /home/simth/${hostname}_${poolname}_${rbdimagename}
  if [ "$?" -eq 0 ];then
   echo ${path_obj}/$i >> /home/simth/${hostname}_${poolname}_${rbdimagename}
   echo ==== $objectname
   md5sum $objectname >> /home/simth/${hostname}_${poolname}_${rbdimagename}
  echo ${path_obj}/$i
  fi
  cd ..
done

done 
