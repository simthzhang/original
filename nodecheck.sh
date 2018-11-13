#!/bin/bash
ceph_node_packagepath=$1
cephnode_pacckagelist=(sds-agent memcached zabbix-agent ctdb lsscsi f2fs_tools_Bodkin ceph storcli redhat-lsb-core ntpdate net-tools perl perl-Config-General scsi-target-utils expect sysstat smartmontools sg3_utils nvme-cli.x86_64 ceph-fuse)
#cephnode_pacckagelist=(perl)

generate_cephpackagelist()
{
    rm -rf tmp.log
    echo generating packagelist in cephnode
    for i in "${!cephnode_pacckagelist[@]}";do
        rpm -qa ${cephnode_pacckagelist[$i]} >>tmp.log
        echo  ${cephnode_pacckagelist[$i]}   
    done
}

check_ceph_node_packagelist()
{
    for j in `cat tmp.log`
    do
        echo ====================
        packagename=`ls -l  ${ceph_node_packagepath}|grep ${j}|awk '{print $9}'`
        ls -l  ${ceph_node_packagepath}|grep ${j} >> /dev/zero
        if [ $? -eq 0 ]; then
            rpm -qi $j|grep -v "Install Date" > 1
            rpm -qpi ${ceph_node_packagepath}/${packagename} |grep -v "Install Date"> 2
            diff ./1 ./2 > /dev/null
            if [ $? == 0 ]; then
               echo "Both file are same"
            else
               echo "Both file are different"
            fi
            installed_buildhost=`rpm -qi $j|grep "^Version"|awk '{print $3}'` > /dev/zero
            package_buildhost=`rpm -qpi ${ceph_node_packagepath}/${packagename}|grep "^Version"|awk '{print $3}'` > /dev/zero
            echo Actual_version: $installed_buildhost
            echo Expect_version: $package_buildhost
            echo $installed_buildhost|grep $package_buildhost > /dev/zero
            if [ $? -eq 0 ]; then
                echo -e "\033[32m $packagename \033[0m"
            else
                echo -e "\033[31m $j \033[0m"
                echo $installed_buildhost $package_buildhost
            fi
        else
            echo -e "\033[31m $j \033[0m" 
        fi
    done
}


generate_cephpackagelist
check_ceph_node_packagelist


