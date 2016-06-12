#!/bin/bash
#instance image volume securitygroup tenant router network floatingip
#This file is aimed at delete thinkstack server resource, you can specify the 

date_file=`date "+%Y_%m_%d_%H_%M_%S"`
rm -rf *.image
rm -rf *.check
rm -rf *.instance
rm -rf *.routerdb
rm -rf *.log
source /root/openrc


function_delete_floatingip()
{
function_listrally_instance
#sleep 2
mysql << EOF
        select sleep(2);
        use neutron;
        select id,floating_ip_address,status from floatingips into outfile '/tmp/$date_file.floatingip';
EOF
      cat /tmp/$date_file.floatingip |awk '{print $2}'
        cat /tmp/$date_file.floatingip | while read myline_floatingip
 do
	# if floating ip is DOWN state, recycle
        echo $myline_floatingip|grep DOWN
        if [ "$?" -eq 0 ]
        then
        neutron floatingip-delete `echo $myline_floatingip|awk '{print $1}'`
        else
	# if floating ip belongs to rally instances, recycle
        cat /tmp/$date_file.instancerally | while read myline_instance
	do
	echo $myline_floatingip
	floating_ipdelete=`echo $myline_floatingip|awk '{print $2}'`
	floating_id=`echo $myline_floatingip|awk '{print $1}'`
	deassociate_instance=`echo $myline_instance|awk '{print $2}'`
	echo `nova show $deassociate_instance`|grep $floating_ipdelete
	if [ "$?" -eq 0 ]
	then
	echo $floating_id 
	neutron floatingip-delete $floating_id

	fi   
	done
	fi
 done
}


#$6=gatewayid $2=id $3=name
#Use neutron router-gateway-clear to clear gateway
#Use router-interface-delete to delete intfaces from router
#Use router-delete to delete router	
#$6=gatewayid $2=id $3=name
#neutron router-gateway-clear "Router"(check name with neutron router-list)
#neutron router-interface-delete "Router" "SubNet"
#neutron router-delete "Router"
#neutron subnet-delete "SubNet"
function_delete_router()
{
mysql << EOF
        select sleep(2);
        use neutron;
        select * from routers where name not like "router04" into outfile '/tmp/$date_file.routerdb';
EOF
	cat /tmp/$date_file.routerdb |awk '{print $2}'
	cat /tmp/$date_file.routerdb | while read myline
	do	
	echo $myline|grep rally
	if [ "$?" -eq 0 ]
	then
	router_todelete=`echo $myline|awk '{print $2}'`
	neutron router-gateway-clear `echo $myline|awk '{print $2}'`
	neutron router-port-list $router_todelete|awk -F "\"" '{print $4}' >>/tmp/tempinterface.log
	cat /tmp/tempinterface.log |grep -v "^$" |while read tempinterface
	do
	neutron router-interface-delete $router_todelete $tempinterface
	done
	rm -rf /tmp/tempinterface.log	
        neutron router-delete $router_todelete
	fi
	done
	
}


function_listrally_instance()
{
mysql << EOF
        select sleep(2);
        use nova;
        select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/$date_file.instance1';
EOF
                cat /tmp/$date_file.instance1 | while read myline
                do
                echo $myline|grep rally >> /tmp/$date_file.instancerally
#                echo $myline >> /tmp/$date_file.instancerally
		#echo "rally instance is: "$myline
		done
}


function_delete_instance()
{
mysql << EOF
	select sleep(2);
	use nova;
	select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/$date_file.instance';
EOF
		cat /tmp/$date_file.instance | while read myline
		do
		echo $myline|grep rally
		if [ "$?" -eq 0 ]
		then
		nova delete `echo $myline|awk '{print $2}'`
		fi
		done
		
}


function_delete_image()
{
mysql << EOF
	select sleep(2);
	use glance;
	select name,id from images where deleted not like "1" into outfile '/tmp/$date_file.image';
EOF
	 cat /tmp/$date_file.image | while read myline
         do
         echo $myline|grep rally
         if [ "$?" -eq 0 ]
	then
	glance image-delete `echo $myline|awk '{print $2}'`
	fi
	done
}

#volume attached should be deattched then delete
#volume datach format nova volume server_id volume_id
function_delete_volume()
{
mysql << EOF
        select sleep(2);
        use cinder;
        select display_name,id,attach_status from volumes where deleted not like "1" into outfile '/tmp/$date_file.volume';
EOF

  cat /tmp/$date_file.volume | while read myline
         do
         echo $myline|grep rally
         if [ "$?" -eq 0 ]
	then
	echo $myline|grep attached
		 if [ "$?" -eq 0 ]
	         then
		volume_id=`echo $myline|awk '{print $2}'`
		echo "volume id is:" $volume_id	
	        server_id=`nova volume-show $volume_id|grep attachments|awk -F "\"" '{print $4}'`
		echo "server_id is:" $server_id
		nova volume-detach $server_id $volume_id
	         fi
        cinder delete `echo $myline|awk '{print $2}'`
	 fi
        done
	








}

#function_delete_network()
#{
#mysql << EOF
#        select sleep(2);
#        use neutron;
#        select id from networks where name not like "net04" and name not like "net04_ext" into outfile '/tmp/$date_file.network';
#EOF
#        neutron net-delete `cat $date_file.network`
#}

function_delete_projectoruseri()
{
mysql << EOF
        select sleep(2);
        use ;
        select id from images where deleted not like "1" into outfile '/tmp/$date_file.image';
EOF
        glance image-delete `cat $date_file.image`
}






#function_delete_instance
#function_delete_router #done
#function_delete_image
#function_delete_volume
function_delete_floatingip
#function_listrally_instance







































































































































































































































