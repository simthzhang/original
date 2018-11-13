#!/bin/bash
imagecount=$1
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
numjob=(1 2)
image_count=(${imagecount})
iodepth=(32 64 128 256 512)
runtime=180
rbdpara="rbd"
log_dir=log

if [ -z "$1" ]; then
    echo "imagecount is empty!"
    echo Sample: "./generate_performance_case.sh <imagenumber>"
    exit
fi


generate()
{
rw=$2
bs=$3
rwmixread=$4
case_num=$1


    #rm -rf log/
    mkdir -p log
    for i in "${!numjob[@]}"; do
        for j in "${!iodepth[@]}";do
            single_iodepth=${iodepth[$j]}
            for k in "${!image_count[@]}";do
               ./case.sh $rbdpara $rw $bs $runtime ${iodepth[$j]} ${numjob[$i]} ${image_count[$k]} $current_date ${rwmixread} ${case_num}
#		echo $rw, $bs,$rwmixread, $case_num
            done
        done
    done
}

fullfill()
{
###############################
#fullfill image,you need update: 
#1. Modify iodepth to 1024G
#2. Remove time_based
#4. Remove runtime
##############################

generate case0 rw 1024k 0
sed -i 's/time_based=1//g' ${log_dir}/*.config
sed -i 's/runtime.*//g' ${log_dir}/*.config
}

performance_rbd()
{

rm -rf log
mkdir log
mkdir log/test


generate case4 randrw 8k 0
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

generate case5 randrw 8k 70
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

generate case6 randrw 8k 100
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..


generate case7 rw 1024k 0
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

generate case8 rw 1024k 70
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

generate case9 rw 1024k 100
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

mv log/test/* log/
generate case5 randrw bssplit 70
sed -i 's/bs=bssplit/bssplit=8k\/50\:1024k\/50/g' ./log/*case5*

}


baredisk_generate()
{

# Be carefore, case order!!!!
# Delete runtime=xxx in 512 iodepth 1024k sequenece write if you want to fullfill disk
rm -rf log 
mkdir log
mkdir log/test

generate case1 rw 1024k 0
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

generate case2 randrw 4k 100
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..
generate case3 rw 1024k 100
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..


generate case4 randrw 4k 0
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..



generate case5 randrw bssplit 70
cd log
ls -l -t |tac |grep config|grep _0.config|awk '{print $9}' >> run_config
mv *.config ./test
cd ..

mv log/test/* log/
rm  -rf log/test

sed -i 's/bs=bssplit/bssplit=8k\/50\:1024k\/50/g' ./log/*case5*
sed -i 's/ioengine\=rbd/ioengine\=libaio/g' ./log/*.config
sed -i 's/clientname=admin//g' ./log/*.config
sed -i 's/pool=rbd//g' ./log/*.config
sed -i 's/rbdname/filename/g' ./log/*.config
sed -i 's/rbd_image/device/g' ./log/*.config
\cp -rf ./log/run_config ./
#replace testimag_xxx to /dev/sdxxxx
./replace_rbdname_to_disk_name.sh $image_count
}

baredisk_generate
#performance_rbd
#fullfill

host_count=`cat ceph_ip.conf|wc|awk '{print $1}'`
c=$[${image_count}*${host_count}]
echo 
echo image_count*host_count:$image_count*$host_count=$c
echo runtime  $runtime
echo pool name $rbdpara
echo numberjob ${numjob[@]:0}
echo iodepth ${iodepth[@]:0}
# ${arr[@]:0}
echo image_count ${image_count[@]:0}

echo =================================
echo ceph node list
cat ceph_ip.conf
echo =================================
echo fioserver list
cat fioserver_list.conf
echo =================================
echo monitored ip list 
cat monitor_ip.conf
