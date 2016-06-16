#!/bin/bash
#instance image volume securitygroup tenant router network floatingip
#This file is aimed at delete thinkstack server resource, you can specify the 

date_file=`date "+%Y_%m_%d_%H_%M_%S"`
rm -rf /tmp/*.floatingip
rm -rf /tmp/*.routerdb
rm -rf /tmp/*.instance
rm -rf /tmp/*.instance1
rm -rf /tmp/*.image
rm -rf /tmp/*.volume
rm -rf /tmp/*.log
source /root/openrc

	#select display_name,id from snapshots where deleted like "0" into outfile '/tmp/$date_file.volumesnapshot';
function_get_resourcefrommysql()
{
	mysql << EOF
	select sleep(2);
	use neutron;
	select id,floating_ip_address,status from floatingips into outfile '/tmp/$date_file.floatingip';
	select sleep(1);
	select * from routers where name not like "router04" into outfile '/tmp/$date_file.routerdb';
	select sleep(1);
	use nova;
	select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/$date_file.instance1';
	select sleep(1);
	select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/$date_file.instance';
	select sleep(1);
	use glance;
	select name,id from images where deleted not like "1" into outfile '/tmp/$date_file.image';
	select sleep(1);
	use cinder;
	select display_name,id,attach_status from volumes where deleted not like "1" into outfile '/tmp/$date_file.volume';
	select id,display_name,status from snapshots where deleted=0 into outfile '/tmp/$date_file.snapshotnotdeleted';
	use keystone;
	select id,name from project into outfile '/tmp/$date_file.project';
EOF
}




function_delete_floatingip()
{
	function_listrally_instance
#mysql << EOF
#        select sleep(2);
#        use neutron;
#        select id,floating_ip_address,status from floatingips into outfile '/tmp/$date_file.floatingip';
#EOF
		cat /tmp/$date_file.floatingip | while read myline_floatingip
		do
# if floating ip is DOWN state, recycle
			echo "FloatingIP in down status: "$myline_floatingip|grep DOWN
				if [ "$?" -eq 0 ]
					then
						neutron floatingip-delete `echo $myline_floatingip|awk '{print $1}'`
				else
# if floating ip belongs to rally instances, recycle
					cat /tmp/$date_file.instancerally | while read myline_instance
						do
							floating_ipdelete=`echo $myline_floatingip|awk '{print $2}'`
								floating_id=`echo $myline_floatingip|awk '{print $1}'`
								deassociate_instance=`echo $myline_instance|awk '{print $2}'`
								echo `nova show $deassociate_instance`|grep $floating_ipdelete >> /tmp/simth.log
								if [ "$?" -eq 0 ]
									then
										echo "FloatingIP used by rally: "$myline_floatingip 
										neutron floatingip-delete $floating_id >> /tmp/$date_file_final.log
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
#mysql << EOF
#        select sleep(2);
#        use neutron;
#        select * from routers where name not like "router04" into outfile '/tmp/$date_file.routerdb';
#EOF
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
#mysql << EOF
#        select sleep(2);
#        use nova;
#        select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/$date_file.instance1';
#EOF
	cat /tmp/$date_file.instance1 | while read myline
		do
			echo $myline|grep rally >> /tmp/$date_file.instancerally
				done
}


function_delete_instance()
{
#mysql << EOF
#        select sleep(2);
#        use nova;
#        select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/$date_file.instance1';
#EOF
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
#mysql << EOF
#	select sleep(2);
#	use glance;
#	select name,id from images where deleted not like "1" into outfile '/tmp/$date_file.image';
#EOF
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
#mysql << EOF
#        select sleep(2);

#        use cinder;
#        select display_name,id,attach_status from volumes where deleted not like "1" into outfile '/tmp/$date_file.volume';
#EOF

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


function_delete_volume_snapshot()
{	
	cat /tmp/$date_file.snapshotnotdeleted | while read myline
	do
	echo $myline|grep rally
	if [ "$?" -eq 0 ]
	then
mysql << EOF
        use cinder;
	update snapshots set deleted=1 where id="`echo $myline|awk '{print $1}'`";
EOF
        echo $myline	
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

function_delete_project()
{
#mysql << EOF
#        select sleep(2);
#        use ;
#        select id from images where deleted not like "1" into outfile '/tmp/$date_file.image';
#EO
	cat /tmp/$date_file.project | while read myline_project
	do
	echo $myline_project|grep rally >> /tmp/simth.log
	if [ "$?" -eq 0 ]
	then
	project_id=`echo $myline_project|awk '{print $2}'`
	echo $project_id
	fi	
	done
}





function_get_resourcefrommysql
#function_delete_instance
#function_delete_router
#function_delete_image
#function_delete_volume
function_delete_volume_snapshot
#function_delete_floatingip
#function_listrally_instance
#function_delete_security
#function_delete_network
#function_delete_project
#function_delete_user

