#!/bin/bash
ceph_node=(192.168.0.63 192.168.0.64 192.168.0.65)
controller_node=(192.168.0.93)
controller_packagepath=$1
cephnode_packagepath=$2
if [ -z "$1" ]; then
    echo "Please input deployment package path!"
    echo Sample: ./checkrpm.sh "<deployment folder path>" e.g. /root/deployment/local_repo/packages/  /tmp/InstallCeph-centos73/local_repo/
    exit
fi

copy_key()
{
    for i in "${!ceph_node[@]}";do
        echo ${ceph_node[$i]} 
        ssh-copy-id ${ceph_node[$i]} 
    done

}
controller_remotescript()
{
    for i in "${!controller_node[@]}"
    do
        scp controllercheck.sh ${controller_node[$i]}:/root/
        echo "***********Trying to check controller node package ${ceph_node[$i]} **************"
        #ssh ${ceph_node[$i]} sh controllercheck.sh $controller_packagepath
        ssh ${controller_node[$i]} sh controllercheck.sh $controller_packagepath
    done

}

node_remotescript()
{
    for i in "${!ceph_node[@]}"
    do  
        scp nodecheck.sh ${ceph_node[$i]}:/root/
        echo ===========Trying to check ceph node package ${ceph_node[$i]} ==========
        ssh ${ceph_node[$i]} sh nodecheck.sh $cephnode_packagepath
    done

}

#copy_key
controller_remotescript
node_remotescript
