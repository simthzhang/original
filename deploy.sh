#!/bin/bash
VIP=192.168.0.99
#ceph_nodeip=(192.168.0.101 192.168.0.23 192.168.0.24)
#ceph_nodehostname=(controller-1 controller-2 controller-3)
ceph_nodeip=(192.168.0.8 192.168.0.9 192.168.0.10)
ceph_nodehostname=(controller-1 controller-2 controller-3)
SDS_TAR_PKG="deployment-standalone-daily_20180928_143.tar.gz"
packagename="${SDS_TAR_PKG}"
TOP_DIR="/root/deployment"
SDS_PKG_URL="http://10.120.16.212/build/ThinkCloud-SDS/tcs_nfvi_centos7.5/"
licensefile="90T_ThinkCloud_Storage_license_trial_2018-09-23.zip"
CEPH_NODE_HOST_USER=root
CEPH_NODE_HOST_PASSWORD=lenovo
IMAGE_NAME="CentOS-7-x86_64-v5"



function modify_dns(){
	if ! grep -q "nameserver.*10.96.1.18" /etc/resolv.conf; then
		echo "nameserver 10.96.1.18" > /etc/resolv.conf
	fi
}
function download_sds(){
	wget ${SDS_PKG_URL}${SDS_TAR_PKG}
}

function check_host_status()
{
ceph_node=$1
#result0 behavior as  ping successfully
ping -c 3 -w 5 $ceph_node >> /dev/null
if [[ $? != 0 ]];then
  result=1
else
  result=0
fi
}

poweroff_server()
{
source /root/openrc
j=0
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
  do
   ip=${ceph_nodeip[${i}]}
   hostname=${ceph_nodehostname[${i}]}
   echo power off server ${hostname}
   
   hostid=`openstack server list|grep ${ip}|awk '{print $2}'`
   openstack  server stop ${hostid}
while :
    do
        check_host_status $ip
        echo $j 
        sleep 10
        if [ $j -eq 30 ];then
            echo $downtime power off host failed >> exception.log
            return 1
        fi
        if [ "${result}" = "1" ]; then
            echo $downtime power off successfully >> exception.log
            break
        fi
        let j++
    done
done

}
rebuild_server()
{
source /root/openrc
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
  do
   ip=${ceph_nodeip[${i}]}
   hostname=${ceph_nodehostname[${i}]}
   echo rebuild server ${hostname}
   hostid=`openstack server list|grep ${ip}|awk '{print $2}'`
   openstack server rebuild --image  ${IMAGE_NAME}  --password lenovo  ${hostid}
   echo sleep 60s for rebuilding vm
   sleep 60
# while :
#    do
 #       check_host_status $ip
 #       sleep 10
 #       echo $j
 #       if [ $j -eq 30 ];then
 #           echo $starttime rebuild  failed >> exception.log
 #           return 1
 #       fi
 #       if [ "${result}" = "0" ]; then
 #           echo $starttime rebuildsuccessfully >> exception.log
 #           break
 #       fi
  #      let j++
  #  done
done

}
poweron_server()
{
source /root/openrc
j=0
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
  do
   ip=${ceph_nodeip[${i}]}
   hostname=${ceph_nodehostname[${i}]}
   echo power on server ${hostname}
   hostid=`openstack server list|grep ${ip}|awk '{print $2}'`
   openstack  server start ${hostid}

 while :
    do
        check_host_status $ip
        sleep 10
        echo $j
        if [ $j -eq 30 ];then
            echo $starttime power on  failed >> exception.log
            return 1
        fi
        if [ "${result}" = "0" ]; then
            echo $starttime power on successfully >> exception.log
            break
        fi
        let j++
    done
done

}

copy_key()
{
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
  do
   ip=${ceph_nodeip[${i}]}
   #ssh $ip mkdir /root/.ssh/
   scp -r /root/.ssh/ $ip:/root/
done


}
set_hostname()
{
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
  do
   ip=${ceph_nodeip[${i}]}
   hostname=${ceph_nodehostname[${i}]}
   ssh ${ip} hostnamectl set-hostname ${hostname}
  done

}
modify_hosts()
{
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
do
echo ${ceph_nodeip[${i}]}
rm -rf hosts.tmp
ip=${ceph_nodeip[${i}]}
hostname=${ceph_nodehostname[${i}]}
echo 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 ${hostname} >> hosts.tmp
echo ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 ${hostname} >> hosts.tmp
echo $VIP api.inte.lenovo.com >> hosts.tmp
echo $VIP controller >> hosts.tmp
scp hosts.tmp ${ip}:/etc/hosts
done
}


disable_firewall_settimezone()
{
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
do
ip=${ceph_nodeip[${i}]}
hostname=${ceph_nodehostname[${i}]}
ssh ${ip} systemctl stop firewalld
ssh ${ip} systemctl disable firewalld
ssh ${ip} setenforce 0
ssh ${ip} timedatectl set-timezone Asia/Shanghai
scp $packagename ${ip}:/root/
ssh ${ip} tar -zxvf ${packagename}
done
}
modify_installconfig()
{
LEN=${#ceph_nodeip[@]}
rm -rf install_config*
echo HA_flag=YES >> install_config_0
echo "#--------------------------------------"  >> install_config_0
echo ManageNetwork=${VIP}  >> install_config_0 #management network VIP
echo PublicNetwork=${VIP}   >> install_config_0 #management network VIP
echo "#--------------------------------------"  >> install_config_0
echo this_node=${ceph_nodeip[0]} >> install_config_0 #current manager IP
echo other_node2=${ceph_nodeip[1]} >> install_config_0 #second manger IP
echo other_node3=${ceph_nodeip[2]} >> install_config_0 #third manager IP
echo "#--------------------------------------"  >> install_config
echo VIP1=${VIP} >> install_config_0 #manager vip
echo CIDR1="24" >> install_config_0

echo HA_flag=YES >> install_config_1
echo "#--------------------------------------"  >> install_config_1
echo ManageNetwork=${VIP}  >> install_config_1 #management network VIP
echo PublicNetwork=${VIP}   >> install_config_1 #management network VIP
echo "#--------------------------------------"  >> install_config_1
echo this_node=${ceph_nodeip[1]} >> install_config_1 #current manager IP
echo other_node2=${ceph_nodeip[0]} >> install_config_1 #second manger IP
echo other_node3=${ceph_nodeip[2]} >> install_config_1 #third manager IP
echo "#--------------------------------------"  >> install_config_1
echo VIP1=${VIP} >> install_config_1 #manager vip
echo CIDR1="24" >> install_config_1

echo HA_flag=YES >> install_config_2
echo "#--------------------------------------"  >> install_config_2
echo ManageNetwork=${VIP}  >> install_config_2 #management network VIP
echo PublicNetwork=${VIP}   >> install_config_2 #management network VIP
echo "#--------------------------------------"  >> install_config_2
echo this_node=${ceph_nodeip[2]} >> install_config_2 #current manager IP
echo other_node2=${ceph_nodeip[1]} >> install_config_2 #second manger IP
echo other_node3=${ceph_nodeip[0]} >> install_config_2 #third manager IP
echo "#--------------------------------------"  >> install_config_2
echo VIP1=${VIP} >> install_config_2 #manager vip
echo CIDR1="24" >> install_config_2

LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
do
ip=${ceph_nodeip[${i}]}
scp install_config_${i} ${ip}:/root/deployment/ha_config/install_config
done

}
install()
{
LEN=${#ceph_nodeip[@]}
for ((i=0; i<${LEN}; i++))
do
ip=${ceph_nodeip[${i}]}
nohup ssh $ip "cd /root/deployment/; ./standalone-setup.sh install -s" &
done
wait
}


exe_allinone()
{
scp install.sh  ${ceph_nodeip[0]}:/root/
ssh -t  ${ceph_nodeip[0]}  ./install.sh
}

function put_license(){
	LOCAL_PATH=`pwd`
	# TOKEN=`keystone token-get | grep "\ id" | awk '{print $4}'`
	# curl -H "LOG_USER: admin" -H "X-Auth-Token: ${TOKEN}" -H "Content-type:application/json"  -X GET http://localhost:9999/v1/license/
	# sleep 5
        scp $licensefile ${VIP}:/root/
        ssh ${VIP} 'licensefile=90T_ThinkCloud_Storage_license_trial_2018-09-23.zip && source /root/localrc && cephmgmtclient update-license -l /root/$licensefile'
}

function create_ceph_cluster(){
	ssh ${VIP} ' source /root/localrc && cephmgmtclient create-cluster --name ceph-cluster-1 --addr vm'
        cluster_id=`ssh ${VIP} ' source /root/localrc && cephmgmtclient list-clusters'`
}

function add_host_to_cluster(){
	LEN=${#ceph_nodehostname[@]}
        rackid=1
        clusterid=`ssh ${VIP} ' source /root/localrc && cephmgmtclient list-clusters'|grep ceph|awk '{print $2}'`
         scp createserver.sh ${VIP}:/root/
	for ((i=0; i<${LEN}; i++))
	do
	#ssh ${VIP} 'source /root/localrc'
          ceph_name=${ceph_nodehostname[${i}]} 
          ceph_ip=${ceph_nodeip[${i}]}
          cluster_ip=${ceph_nodeip[${i}]}
          manager_ip=${ceph_nodeip[${i}]}
         ssh ${VIP} /root/createserver.sh ${clusterid} ${ceph_name} ${ceph_ip} ${cluster_ip} ${manager_ip} ${CEPH_NODE_HOST_USER} ${CEPH_NODE_HOST_PASSWORD} ${rackid}
	#ssh ${VIP} 'source /root/localrc; cephmgmtclient create-server --id 1 --name ${ceph_name} --publicip ${ceph_ip} --clusterip ${ceph_ip} --server_user ${CEPH_NODE_HOST_USER} --server_pass ${CEPH_NODE_HOST_PASSWORD} --rack_id 1'

#cephmgmtclient create-server --id <cluster_id> --name <server_name>
#                                    --managerip <manager_ip> --publicip
 #                                   <public_ip> --clusterip <cluster_ip>
  #                                  --server_user <user_name> --server_pass
   #                                 <password> --rack_id <RACK_ID>
    #                                [--ipmi_ip <ipmi_ip>]
     #                               [--ipmi_user <ipmi_user>]
      #                              [--ipmi_pwd <ipmi_pwd>]
       #                             [--ipmi_port <ipmi_port>]

	done
}

function deploy_ceph_cluster(){
	source /root/localrc
	cephmgmtclient deploy-cluster 1
}

#poweroff_server
#echo sleep 60 seconds for powering off
#sleep 60
#rebuild_server
#poweron_server
#copy_key
#modify_dns
#download_sds
#modify_installconfig
#set_hostname
#modify_hosts
#disable_firewall_settimezone
#modify_installconfig
install
exe_allinone
put_license
create_ceph_cluster
#add_host_to_cluster
