#!/bin/bash

#chieck if fio is installed
function_check_rally_dir()
{
	echo `ls /tmp`|grep rally_scalability >> /tmp/tmp.log
		if [ $? -ne 0 ]
			then
				mkdir rally_scalability
				fi

}
check_fio()
{
	fio|grep apt
		if [$? -eq 0 ] 
			then
				echo dpkg -i xxx.deb
				fi
}

function_dd_fio()
{
mkdir –p /test

rm /test/result.log

date

#urandom 函数会密集调用cpu资源，生存的随机内容写入hello文件，大小100M左右
time dd if=/dev/urandom of=/test/hello bs=10M count=10 oflag=direct
echo urandom
time dd of=/dev/null if=/test/hello bs=10M count=10 iflag=direct
echo null
fio --filename=/test/hello  --direct=1 --rw=randwrite --bs=4k --size=10M --numjobs=10 --runtime=20 --name=file1 --ioengine=aio --iodepth=32 --group_reporting
echo randwrite 4k
fio --filename=/test/hello  --direct=1 --rw=randread  --bs=4k --size=10M --numjobs=10 --runtime=20 --name=file1 --ioengine=aio --iodepth=32 --group_reporting
echo randread 4k

}

function_compute()
{
		multiplier1=`echo $RANDOM`
		multiplier2=`echo $RANDOM`
		echo $multiplier1
		echo $multiplier2
		let "product=$multiplier1 * $multiplier2"
#		echo $produc
		echo $multiplier1 x $multiplier2 = $product tag_simth >> /tmp/rally_scalability/test.txt

}

#function_storage()
#{
#}

#function_network()
#{
#}
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

cd /tmp

#function_check_rally_dir
#function_compute
#function_check_ifprime
function_dd_fio
