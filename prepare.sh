#!/bin/bash
#check all instances and group them
rm -rf /tmp/scalability
mkdir /tmp/scalability
vm_dir=/tmp/scalability

list_vms()
{
#head with test
	#nova list|awk '{if($4 ~ /^test*/) print $0;}' >> $vm_dir/vms.tmp
	nova list|awk '{if($4 ~ /^scalability*/) print $0;}' >> $vm_dir/vms.tmp
}

vm_groups()
{
	rm -rf $vm_dir/filter.log
		rm -rf $vm_dir/*.group
				cat $vm_dir/vms.tmp|awk '{print $12}'|awk -F "=" '{print $1}'|sort -u  >> $vm_dir/filter.log #collect different vms in diff networks
				cat $vm_dir/filter.log |while read filtervms
				do
				cat $vm_dir/vms.tmp|grep $filtervms >> $vm_dir/$filtervms.group
				done
				}

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
associate_floatingip()
				{
				./delete_resource.sh
				rm -rf $vm_dir/serverid_floatingip.log
				floatingip_count=`cat $vm_dir/filter.log|wc -l`
				echo create_floatingIP_count: $floatingip_count
				touch $vm_dir/serverid_floatingip.log
				touch $vm_dir/fail_serverid_floatingip.log
				for (( i=1; i<=$floatingip_count; i++ ))
				do
				group_name=`sed -n "${i} p" $vm_dir/filter.log`
				vm_count=`cat $vm_dir/$group_name.group|wc -l` 
				echo vm_count: $vm_count in $group_name --check /tmp/scalability/$group_name.group for detail
				for (( j=1; j<=$vm_count; j++ ))
				do

				server_id=`sed -n  "${j} p" $vm_dir/$group_name.group|awk '{print $2}'`
				#echo server_id: $server_id
				server_name=`sed -n "${j} p" $vm_dir/$group_name.group|awk '{print $4}'`
				#echo server_name: $server_name
				nova show $server_id |grep 15.15.15 &> $vm_dir/tmp.log 

				if [ $? -ne 0 ]
				then
####################
#Check if floating can be accessed
#Use the vms in group until the floating ip is available
####################
#get floating ip
floating_ipaddress=`nova floating-ip-create |sed -n 4P|awk '{print $4}'`
#associate floating ip to vm

nova floating-ip-associate $server_id  $floating_ipaddress 
successful_associate=`check_ping $floating_ipaddress`
if [ $successful_associate -eq 0 ];then
echo $group_name $server_id $server_name $floating_ipaddress >> $vm_dir/serverid_floatingip.log
echo The $j th times id: $server_id name: $server_name floatingIP:$floating_ipaddress
break
else
echo $group_name $server_id $server_name $floating_ipaddress >> $vm_dir/fail_serverid_floatingip.log
nova floating-ip-disassociate $server_id  $floating_ipaddress
nova floating-ip-delete $floating_ipaddress
fi

else
exsit_ip=`nova floating-ip-list |grep $server_id|awk '{print $4}'`
successful_associate1=`check_ping $exsit_ip`
if [ $successful_associate1 -eq 0 ];then
echo $group_name $server_id $server_name $exsit_ip >> $vm_dir/serverid_floatingip.log 
echo The $j times id:$server_id name: $server_name floatingIP: $exsit_ip
break
else
		echo $group_name $server_id $server_name $exsit_ip >> $vm_dir/fail_serverid_floatingip.log
		nova floating-ip-disassociate $server_id  $exsit_ip
		nova floating-ip-delete $floating_ipaddress

		fi

		cat $vm_dir/serverid_floatingip.log|grep $server_id >> /tmp/tmp.log
		if [ $? -ne 0 ]
			then
				if [ $successful_associate1 -eq 0 ];then
					echo $group_name $server_id $server_name $exsit_ip >> $vm_dir/serverid_floatingip.log 
					echo The $jth $server_id $exsit_ip
						break
				else
					echo $group_name $server_id $server_name $exsit_ip >> $vm_dir/fail_serverid_floatingip.log
						nova floating-ip-disassociate $server_id  $exsit_ip
						nova floating-ip-delete $floating_ipaddress

						fi
						fi

						fi
						done
						done
}

file_transfer()
{
#network1 7cebf7cd-8152-4151-8d50-19eba405dd90 scalability_vm1-1 15.15.15.54
cat $vm_dir/serverid_floatingip.log|while read myline
do
groupname=`echo $myline|awk '{print $1}'`
echo $groupname
floatingip=`echo $myline|awk '{print $4}'`
echo $floatingip 
expect <<-END2
      spawn scp $vm_dir/$groupname.group /home/simth/exec_script.sh /home/simth/timer.conf internal_disbribute.sh root@$floatingip:/home/simth 
       set timeout 600
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

	spawn ssh root@$floatingip
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
	expect "root@*"
	send "cd /home/simth && hostname && ls -l && ./internal_disbribute.sh\r"
        expect "*"
        send "exit\r"
        expect eof
END2
#        expect "timer.sh"
 #       send "./timer.sh\r"

done



}
source openrc
#source /root/openrc
list_vms
vm_groups
associate_floatingip
file_transfer
