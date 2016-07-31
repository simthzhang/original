#!/bin/bash
#instance image volume securitygroup tenant router network floatingip
#This file is aimed at delete thinkstack server resource, you can specify the 
#Provide mysql or openstack command methods to collect rally resource

date_file=`date "+%Y_%m_%d_%H_%M_%S"`
rm -rf /tmp/simth*
source /root/openrc
	
	     function_get_resourcefrommysql()
	     {
	     mysql << EOF
	     select sleep(2);
	     use neutron;
	     select id,floating_ip_address,status from floatingips into outfile '/tmp/simth_$date_file.floatingip';
	     select * from routers where name not like "router04" into outfile '/tmp/simth_$date_file.routerdb';
	     select * from securitygroups into outfile '/tmp/simth_$date_file.securitygroups';
	     select id,network_id,device_owner,device_id from ports into outfile '/tmp/simth_$date_file.portlist';
	     select id,name from networks into outfile '/tmp/simth_$date_file.networks';
	     use nova;
	     select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/simth_$date_file.instance1';
	     select display_name,uuid from instances where vm_state not like "deleted" into outfile '/tmp/simth_$date_file.instance';
	     use glance;
	     select name,id from images where deleted not like "1" into outfile '/tmp/simth_$date_file.image';
	     use cinder;
	     select display_name,id,attach_status from volumes where deleted not like "1" into outfile '/tmp/simth_$date_file.volume';
	     select id,display_name,status from snapshots where deleted=0 into outfile '/tmp/simth_$date_file.snapshotnotdeleted';
	     use keystone;
	     select id,name from project into outfile '/tmp/simth_$date_file.project';
	     select id,name from user into outfile '/tmp/simth_$date_file.user';
	     select id,name from role into outfile '/tmp/simth_$date_file.role';
	     	
EOF
	     }

#Retrive data from openstack command
function_get_resoure_fromcommnad()

{
echo floatingip is:
neutron floatingip-list
echo router is:
neutron router-list
echo Instance is:
nova list --all-tenant
nova list --all-tenant
echo image is:
glance image-list --all-tenant
echo volume is:
nova volume-list --all-tenant
echo securitygroup is:
neutron security-group-list
echo userlist is:
openstack user list
echo project list is:
openstack project list
echo network list
neutron net-list
}


function_delete_floatingip()
{
function_listrally_instance
cat /tmp/simth_$date_file.floatingip | while read myline_floatingip
do
# if floating ip is DOWN state, recycle
echo "FloatingIP in down status: "$myline_floatingip|grep DOWN
if [ "$?" -eq 0 ]
then
neutron floatingip-delete `echo $myline_floatingip|awk '{print $1}'`
else
# if floating ip belongs to rally instances, recycle
cat /tmp/simth_$date_file.instancerally | while read myline_instance
do
floating_ipdelete=`echo $myline_floatingip|awk '{print $2}'`
floating_id=`echo $myline_floatingip|awk '{print $1}'`
deassociate_instance=`echo $myline_instance|awk '{print $2}'`
echo `nova show $deassociate_instance`|grep $floating_ipdelete >> /tmp/simth.log
if [ "$?" -eq 0 ]
then
echo "FloatingIP used by rally: "$myline_floatingip 
neutron floatingip-delete $floating_id >> /tmp/simth_$date_file_final.log
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
	cat /tmp/simth_$date_file.routerdb |awk '{print $2}'
		cat /tmp/simth_$date_file.routerdb | while read myline
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
	cat /tmp/simth_$date_file.instance1 | while read myline
		do
			echo $myline|grep rally >> /tmp/simth_$date_file.instancerally
				done
}


function_delete_instance()
{
	cat /tmp/simth_$date_file.instance | while read myline
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
	cat /tmp/simth_$date_file.image | while read myline
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
	cat /tmp/simth_$date_file.volume | while read myline
		do
			echo $myline|grep rally
				if [ "$?" -eq 0 ]
					then
						echo $myline|grep attached
						volume_id=`echo $myline|awk '{print $2}'`
						if [ "$?" -eq 0 ]
							then
#								volume_id=`echo $myline|awk '{print $2}'`
								echo "volume id is:" $volume_id	
								server_id=`nova volume-show $volume_id|grep attachments|awk -F "\"" '{print $4}'`
								echo "server_id is:" $server_id
								nova volume-detach $server_id $volume_id
						fi
						cinder reset-state $volume_id
						#cinder delete `echo $myline|awk '{print $2}'`
						cinder delete $volume_id
		 		fi
		done


}


function_delete_volume_snapshot()
{	
	cat /tmp/simth_$date_file.snapshotnotdeleted | while read myline
#cat /tmp/ddd | while read myline
		do
			echo $myline|grep rally
				if [ "$?" -eq 0 ]
					then
mysql << EOF
						use cinder;
		update snapshots set deleted=1 where id="`echo $myline|awk '{print $1}'`";
		update snapshots set status="deleted" where id="`echo $myline|awk '{print $1}'`";
EOF
			echo $myline	
			fi
			done
}
#2id 3 name
function_delete_securitygroups()
{
#Ensure Instance does not use security group
#method1: collect all rally related security
#method2: collect all rally related instnace and then check if security is bonding to rally related security groups
	cat /tmp/simth_$date_file.securitygroups |while read myline_securitygroups
		do
			echo $myline_securitygroups|grep rally >> /tmp/simth.log
				if [ "$?" -eq 0 ]
					then
						cat /tmp/simth_$date_file.instance1 | while read rallyinstances
						do
							echo rally instance is: $rallyinstances
								echo security group is: $myline_securitygroups|awk '{print $2}'
								nova remove-secgroup `echo $rallyinstances|awk '{print $2}'` `echo $myline_securitygroups|awk '{print $2}'`
								done
								nova secgroup-delete `echo $myline_securitygroups|awk '{print $2}'`
								fi  
								done
}

function_delete_network()
{
# id,network_id,device_owner,device_id
#detach vm port from network
#nova interface-detach instanceid portid
#1./tmp/port_list: Use sql collect netid&portid&porttype   select id,network_id,device_owner from ports;
#2.chose which network you want to delete 
#3.fileter the router portid and compute portid deviceid from /tmp/port_list
#4.detach compute port: nova interface-detach instanceid(deviceid) portid
#5.detach router port: 
#6.delete network
	cat /tmp/simth_$date_file.networks | while read myline_network
		do
			echo $myline_network|grep rally >> /tmp/simth.log 
				if [ "$?" -eq 0 ]
					then
						echo network is: $myline_network
						myline_network_id=`echo $myline_network|awk '{print $1}'`
						cat /tmp/simth_$date_file.portlist |while read myline_portlist
						do
							#myline_network_id=`echo $myline_network|awk '{print $1}'`
#echo $myline_network_id      
								echo $myline_portlist| grep $myline_network_id| grep compute >> /tmp/simth.log

								if [ "$?" -eq 0 ]
									then
										nova interface-detach	`echo $myline_portlist|awk '{print $4, $1}'`
#nova interface-detach instanceid portid
										fi
										echo $myline_portlist| grep $myline_network_id| grep compute >> /tmp/simth.log
										if [ "$?" -eq 0 ]
											then
												nova interface-detach  `echo $myline_portlist|awk '{print $4, $1}'`
#nova interface-detach instanceid portid
												fi
												echo $myline_portlist| grep $myline_network_id| grep router_interface >> /tmp/simth.log	
												if [ "$?" -eq 0 ]
													then
														echo myline_network_id $myline_network_id
														router_id=`echo $myline_portlist|awk '{print $4}'`
														echo router_id $router_id
														net_id=`echo $myline_portlist|awk '{print $2}'`
														echo net_id $net_id
														subnet_net_id=`neutron net-show $net_id|grep subnets|awk '{print $4}'`
														echo subnet_net $subnet_net_id
#echo subnet_id $subnet_id
														neutron router-interface-delete $router_id $subnet_net_id
														fi
														done
														echo trying to delete $myline_network_id
														neutron net-delete $myline_network_id				
														fi
														done

}

function_delete_prj_user_role()
{
	cat /tmp/simth_$date_file.$1 | while read myline
		do
			echo $myline|grep rally >> /tmp/simth.log
				if [ "$?" -eq 0 ]
					then
						id=`echo $myline|awk '{print $1}'`
						echo trying to delete $1  $id
						openstack $1 delete $id
						fi	
						done
}

function_get_resourcefrommysql

#function_delete_instance
#function_delete_router
#function_delete_image
#function_delete_volume
#function_delete_volume_snapshot
function_delete_floatingip
#function_listrally_instance
#function_delete_securitygroups
#function_delete_network
#function_delete_prj_usr_role
#function_delete_user
#function_delete_userrole
#function_delete_prj_user_role project
#function_delete_prj_user_role user
#function_delete_prj_user_role role
tar -zcf $date_file.tar.gz /tmp/simth*
