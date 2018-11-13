#!/bin/bash
image_size=1024
image_begin=0
image_pool=testpool
snapshot_count=250
create_pool()
{
 ceph osd pool create $test 2048
}
delete_pool()
{
ceph osd pool delete $test $test  --yes-i-really-really-mean-it

}

create_image()
{
image_count=$1
for (( i=$image_begin;i<$image_count;i++ ));do
    rbd create testimage_100GB_$i --image-format 2 --size ${image_size} --pool $image_pool
    rbd info -p $image_pool --image testimage_100GB_$i
done
}

count()
{
 count_rbd=`rbd -p $image_pool |wc`
 echo rbd count is: $count_rbd
}

rand(){  
    min=$1  
    max=$(($2-$min+1))  
    num=$(($RANDOM+1000000000)) #增加一个10位的数再求余  
    echo $(($num%$max+$min))  
}
generate_case()
{
rnd=$1
echo ===== $rnd
rm -rf ./case_performance 
echo \[global\] >> ./case_performance
echo ioengine=rbd >> ./case_performance
echo clientname=admin >> ./case_performance
echo pool=test >> ./case_performance
echo rw=randrw >> ./case_performance
echo bs=8k >> ./case_performance
echo runtime=2 >> ./case_performance
echo iodepth=32 >> ./case_performance
echo numjobs=1 >> ./case_performance
echo direct=1 >> ./case_performance
echo rwmixread=70 >> ./case_performance
echo new_group >> ./case_performance
echo group_reporting >> ./case_performance
echo \[rbd_image0\] >> ./case_performance
echo rbdname=testimage_100GB_$rnd >> ./case_performance

}
run_fio()
{
rm -rf performance.result
for((i=0;i<100;i++));
do 
 rnd=$(rand 0 40000)
 echo ================== testimage $rnd ================= >> performance.result
 generate_case $rnd
 fio-2.14/fio ./case_performance  >> performance.result
done
}
create_snap()
{
  create_image 1
  for((i=0;i<$snapshot_count;i++));do
  generate_case 0
  fio-2.14/fio ./case_performance
  rbd snap create ${image_pool}/testimage_100GB_0@snap_testimage_100GB_$i
 done
}
ls_snap()
{
rbd snap ls ${image_pool}/testimage_100GB_0
}
del_snap()
{
 for((i=0;i<$snapshot_count;i++));do
rbd snap rm ${image_pool}/testimage_100GB_0@snap_testimage_100GB_$i
 done
}

#create_pool
#create_image 1
#run_fio
delete_pool
#create_snap
#ls_snap
#del_snap
