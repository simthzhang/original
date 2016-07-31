#!/bin/bash

check_ping()
{
	IP=$1
		ping -c 2 $IP >> /dev/null
		if [ $? -eq 0 ]
			then
				echo 0
		else
			echo 1
				fi
}

internal_distribute()
{
cd /home/simth
#rm -rf ./*.ip_address
rm -rf ./*.log
rm -rf ./ip.internal

##if do not use this it will copy the files to myown too
cat ./*.group| while read myline
do
echo $myline|grep 15.15.15
if [ $? -eq 0 ];then
echo ++++++ $myline
else
echo $myline|awk '{print $12}'|awk -F "," '{print $1}'|awk -F "=" '{print $2}'>> ip.internal
echo +++++++++++++++++++ $myline|awk '{print $12}'|awk -F "," '{print $1}'|awk -F "=" '{print $2}' 
fi
done


cat ./ip.internal|while read myline
do
#internalip=`echo $myline|awk '{print $12}'|awk -F "," '{print $1}'|awk -F "=" '{print $2}'`
internalip=$myline
echo ssssssssssssssss $internalip
host_name=`hostname`
ping_internalip=`check_ping $internalip`
if [ $? -eq 0 ];then
echo $host_name $ping_internalip >> ./success_ip.log
echo internal hostname and ip $host_name $internalip
expect <<-END2
      spawn scp ./timer.sh ./timer.conf exec_script.sh root@$internalip:/home/simth 
       set timeout 30
        expect {
           #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
           expect "password:"
               send "root\r"
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "root\r"
            }
        }

        spawn ssh root@$internalip
      expect {
           #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
           expect "password:"
               send "root\r"
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "root\r"
            }
        }
        expect "*"
        send "cd /home/simth && hostname && ls && ./timer.sh\r"
        expect "*"
        send "exit\r"
        expect eof
END2



else
echo $host_name $internalip >> ./fail_ip.log
echo $host_name $internalip

fi
done
}





internal_distribute
