#!/bin/bash
single_thread=1
four_thread=1
eight_thread=1
twenty_four_thread=1
fourty_eight_thread=1
ninty_six_thread=1
sleep_time=1
#rm -rf ./$date_dir/*.log
date_dir=`date "+%Y_%m_%d_%H_%M_%S"_client`
mkdir $date_dir
run_cycle=5 #determine how many cycles we should run
ip_address=192.168.11.3 #destination address
run_time=1 #run time for each cycle

echo Start collect basic info
# collect os info
echo "CPUINFO:"       `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c` >> ./$date_dir/basicinfo_client.log 
echo "Total Memory:"  `cat /proc/meminfo |grep "MemTotal:"` >> ./$date_dir/basicinfo_client.log
echo "Brand:" >> ./$date_dir/basicinfo_client.log
dmidecode | grep -A15 "System Information" >> ./$date_dir/basicinfo_client.log
echo "Mac_INFO:"  `ifconfig -a|grep "ether"` >> ./$date_dir/basicinfo_client.log
echo "IP_Address:" `ifconfig |grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.'|awk -F " " '{print $2;print "\n"}'` >> ./$date_dir/basicinfo_client.log
#echo "RELEASE_VERSION:" `cat /etc/redhat-release` >> ./$date_dir/basicinfo_client.log
echo `ethtool -i eth0` >> ./$date_dir/basicinfo_client.log
echo `ethtool -k eth0` >> ./$date_dir/basicinfo_client.log

echo "destination ip is:" $ip_address
echo "destination ip is:" $ip_address >> ./$date_dir/basicinfo_client.log
echo "logdir is:" $date_dir >> ./$date_dir/basicinfo_client.log
echo "---------------------------------------------------------" >> ./$date_dir/basicinfo_client.log
echo collect basicinfo_client done

echo	"1thread_retry" >> ./$date_dir/retry.log
echo	"1thread_summary" >> ./$date_dir/summary.log
while (( $single_thread<=$run_cycle ))
do
	iperf3 -c $ip_address -P1 -t$run_time >> ./$date_dir/1thread.log
	echo "Single_Thread:""$single_thread" cycle done
	let "single_thread++"
	sleep $sleep_time
done
cat ./$date_dir/1thread.log| while read myline #read line from ori-result
do
	if [[ "$myline"x =~ "sender" ]]
	then 
		#	if [$myline = "sender"];
		echo	$myline >> ./$date_dir/1thread_summary.log
		echo	$myline|awk -F ' ' '{print $7}' >> ./$date_dir/summary.log
		echo	$myline|grep "sender"|awk -F ' ' '{print $9}' >> ./$date_dir/retry.log
	fi
	if [[ "$myline"x =~ "receiver" ]]

	then
		echo $myline >> ./$date_dir/1thread_summary.log
		echo	$myline|awk -F ' ' '{print $7}' >> ./$date_dir/summary.log
	fi
done

echo	"4thread_retry" >> ./$date_dir/retry.log
echo	"4thread_summary" >> ./$date_dir/summary.log
while (( $four_thread<=$run_cycle ))
do
	iperf3 -c $ip_address -P4 -t$run_time >> ./$date_dir/4thread.log
	echo "Four_Thread:""$four_thread" cycle done ""
	let "four_thread++"
	sleep $sleep_time

done

cat ./$date_dir/4thread.log| while read myline #read line from ori-result
do
	if [[ "$myline"x =~ "sender" ]] && [[ "$myline"x =~ "SUM" ]]  
	then
		echo    $myline >> ./$date_dir/4threads_summary.log
		echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
		echo	$myline|grep "sender"|awk -F ' ' '{print $8}' >> ./$date_dir/retry.log
	fi
	if [[ "$myline"x =~ "receiver" ]]&& [[ "$myline"x =~ "SUM" ]]

	then
		echo $myline >> ./$date_dir/4threads_summary.log
		echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
	fi
done



echo	"8thread_retry" >> ./$date_dir/retry.log
echo	"8thread_summary" >> ./$date_dir/summary.log
while (( $eight_thread<=$run_cycle ))
do
	iperf3 -c $ip_address -P8 -t$run_time >> ./$date_dir/8thread.log
	echo "Eight_Thread:""$eight_thread" cycle done ""
	let "eight_thread++"
	sleep $sleep_time

done
cat ./$date_dir/8thread.log| while read myline #read line from ori-result
do
	if [[ "$myline"x =~ "sender" ]] && [[ "$myline"x =~ "SUM" ]]  
	then
		echo    $myline >> ./$date_dir/8threads_summary.log
		echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
		echo	$myline|grep "sender"|awk -F ' ' '{print $8}' >> ./$date_dir/retry.log
	fi
	if [[ "$myline"x =~ "receiver" ]] && [[ "$myline"x =~ "SUM" ]]  
	then
		echo $myline >> ./$date_dir/8threads_summary.log
		echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
	fi
done



echo	"24thread_retry" >> ./$date_dir/retry.log
echo	"24thread_summary" >> ./$date_dir/summary.log
while (( $twenty_four_thread<=$run_cycle ))
do
	iperf3 -c $ip_address -P24 -t$run_time >> ./$date_dir/24thread.log
	echo "Twenty_four_Thread:""$twenty_four_thread" cycle done ""
	let "twenty_four_thread++"
	sleep $sleep_time

done
cat ./$date_dir/24thread.log| while read myline #read line from ori-result
		do
			if [[ "$myline"x =~ "sender" ]] && [[ "$myline"x =~ "SUM" ]]
			then
				echo    $myline >> ./$date_dir/24threads_summary.log
				echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
				echo	$myline|grep "sender"|awk -F ' ' '{print $8}' >> ./$date_dir/retry.log
			fi
			if [[ "$myline"x =~ "receiver" ]] && [[ "$myline"x =~ "SUM" ]]
			then
				echo $myline >> ./$date_dir/24threads_summary.log
				echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
			fi
		done




echo	"48thread_retry" >> ./$date_dir/retry.log
echo	"48thread_summary" >> ./$date_dir/summary.log
while (( $fourty_eight_thread<=$run_cycle ))
		do
			iperf3 -c $ip_address -P48 -t$run_time >> ./$date_dir/48thread.log
			echo "Fourty_eight_Thread:""$fourty_eight_thread" cycle done ""
			let "fourty_eight_thread++"
	sleep $sleep_time

		done
		cat ./$date_dir/48thread.log| while read myline #read line from ori-result
	do
		if [[ "$myline"x =~ "sender" ]] && [[ "$myline"x =~ "SUM" ]]
		then
			echo    $myline >> ./$date_dir/48threads_summary.log
			echo	$myline|grep "sender"|awk -F ' ' '{print $8}' >> ./$date_dir/retry.log
			echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
		fi
		if [[ "$myline"x =~ "receiver" ]] && [[ "$myline"x =~ "SUM" ]]
		then
			echo $myline >> ./$date_dir/48threads_summary.log
			echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
		fi
	done

echo	"96thread_retry" >> ./$date_dir/retry.log
echo	"96thread_summary" >> ./$date_dir/summary.log
	while (( $ninty_six_thread<=$run_cycle ))
	do
		iperf3 -c $ip_address -P96 -t$run_time >> ./$date_dir/96thread.log
		echo "ninty_six_Thread:""$ninty_six_thread" cycle done ""
		let "ninty_six_thread++"
	sleep $sleep_time

	done
	cat ./$date_dir/96thread.log| while read myline #read line from ori-result
do
	if [[ "$myline"x =~ "sender" ]] && [[ "$myline"x =~ "SUM" ]]
	then
		echo    $myline >> ./$date_dir/96threads_summary.log
		echo	$myline|grep "sender"|awk -F ' ' '{print $8}' >> ./$date_dir/retry.log
		echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
	fi
	if [[ "$myline"x =~ "receiver" ]] && [[ "$myline"x =~ "SUM" ]]
	then
		echo $myline >> ./$date_dir/96threads_summary.log
		echo	$myline|awk -F ' ' '{print $6}' >> ./$date_dir/summary.log
	fi
done

tar -zcf $date_dir.tar.gz ./$date_dir
echo "logdir is:" $date_dir
