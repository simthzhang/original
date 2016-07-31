#!/bin/bash
test_dir=/home/simth/scalability

function_load_ELK()
{
	kill -9 `ps aux|grep logstash`
		/opt/logstash/bin/logstash -f /home/simth/logstashconfig/simthels_fio_send.conf &
}

function_vm_load()
{

rm -rf /home/simth/scalability
mkdir -p $test_dir
sleep 1
localip=`ifconfig eth0|grep inet|sed -n 1p|awk '{print $2}'` 
current_time=`date "+%Y_%m_%d_%H_%M_%S"`
hard_disk=`fdisk -l|grep Disk|sed -n 1p|awk '{print $2$3$5$6}'`
host_name=`hostname`
#urandom 函数会密集调用cpu资源，生存的随机内容写入hello文件，大小100M左右
echo  $localip $hard_disk>> $test_dir/disk_ip.log


time dd if=/dev/urandom of=$test_dir/hello bs=10M count=10 oflag=direct
if [ $? -eq 0 ]; then
echo $host_name $current_time dd_urandom_100MB created successfully >> $test_dir/dd_urandom.log
else
echo $host_name $current_time dd_urandom_100MB created fail >> $test_dir/dd_urandom.log
fi
sleep 1
time dd of=/dev/null if=$test_dir/hello bs=10M count=10 iflag=direct
if [ $? -eq 0 ]; then
echo $host_name $current_time dd_null_100MB_created_successfully >> $test_dir/dd_null.log
else
echo $host_name $current_time  dd_null_100MB_created_fail >> $test_dir/dd_null.log
fi
./fio --filename=$test_dir/hello  --direct=1 --rw=randwrite --bs=4k --size=10M --numjobs=10 --runtime=20 --name=file1 --ioengine=aio --iodepth=32 --group_reporting |tee $test_dir/fio_randwrite_4k_result
sleep 1
cat $test_dir/fio_randwrite_4k_result|while read myline
do
echo $myline|grep  iops
if [ $? -eq 0 ]; then
echo ${host_name} ${current_time}$myline |tee  $test_dir/fio_randwrite_4k_result.log
fi
done
./fio --filename=$test_dir/hello  --direct=1 --rw=randread  --bs=4k --size=10M --numjobs=10 --runtime=20 --name=file1 --ioengine=aio --iodepth=32 --group_reporting |tee $test_dir/fio_randread_4k_result
sleep 1
cat $test_dir/fio_randread_4k_result|while read myline
do
echo $myline|grep  iops
if [ $? -eq 0 ];then
echo  ${host_name} ${current_time} $myline |tee  $test_dir/fio_randread_4k_result.log
fi
done
}


function_compute()
{
multiplier1=`echo $RANDOM`
multiplier2=`echo $RANDOM`
echo $multiplier1
echo $multiplier2
let "product=$multiplier1 * $multiplier2"
echo $multiplier1 x $multiplier2 = $product tag_simth >> /tmp/rally_scalability/test.txt

}

function_check_ifprime()
{
	current_date=`date "+%Y_%m_%d_%H_%M_%S"`
		echo current_date is: $current_date
		final_number=`tail -1 /tmp/rally_scalability/test.txt|awk '{print $5}'`
		if [ -z $final_number ];then
			echo Usage:$0 num
				exit 0
				fi
				for (( i=2; i<=$final_number;i++ ));do 
					flag=0;
	for (( j=2;j<=i/2;j++ )); do  
		if ((i%j==0));then
			flag=1;
	echo == $i $j
		break;  
	fi  
		done
		done
		if (($flag));then
			echo $N is not a prime number;
		else
			echo $N is a prime number;
	fi
		end_date=`date "+%Y_%m_%d_%H_%M_%S"`
		echo end_date is: $end_date
}


main()
{

cd /home/simth
#
#*/1 * * * * /home/simth/exec_script.sh
#function_load_ELK
function_vm_load
#function_compute
#function_check_ifprime
}


main
