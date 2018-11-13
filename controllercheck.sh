#!/bin/bash
controller_packagepath=$1
controller_packagelist=(storagemgmt-client mariadb mariadb-server python2-PyMySQL zabbix-server-mysql zabbix-web zabbix-web-mysql python-memcached memcached openstack-keystone python-keystoneclient python-django-horizon openstack-dashboard rabbitmq-server python-IPy storagemgmt-api snmpsubagent ntp)


generate_controllerpackagelist()
{
    rm -rf tmp.log
    echo generating packagelist in controller
    for i in "${!controller_packagelist[@]}";do
        rpm -qa ${controller_packagelist[$i]} >>tmp.log
        echo  ${controller_packagelist[$i]}   
    done
}

check_controller_packagelist()
{
    for j in `cat tmp.log`
    do
        echo ===============
        packagename=`ls -l  ${controller_packagepath}|grep ${j}|awk '{print $9}'`
        ls -l  ${controller_packagepath}|grep "zabbix-web-3.0.13-2.el7.noarc" >> /dev/zero
        if [ $? -eq 0 ]; then
            rpm -qi $j|grep -v "Install Date" > 1
            rpm -qpi ${controller_packagepath}/${packagename} |grep -v "Install Date"> 2
            diff ./1 ./2 > /dev/null
            if [ $? == 0 ]; then
               echo "Both file are same"
            else
               echo "Both file are different"
            fi

            installed_buildhost=`rpm -qi $j|grep "^Version"|awk '{print $3}'` 
            package_buildhost=`rpm -qpi ${controller_packagepath}/${packagename}|grep "^Version" |awk '{print $3}'`
            echo $installed_buildhost
            echo $package_buildhost
            echo $installed_buildhost|grep $package_buildhost > /dev/zero
            if [ $? -eq 0 ]; then
                echo -e "\033[32m $packagename \033[0m"
            else 
                echo -e "\033[31m $j \033[0m"
                echo $installed_buildhost $package_buildhost
            fi
        else
            #echo $j
            echo -e "\033[31m installed $j \033[0m"
        fi
    done
}

generate_controllerpackagelist 
check_controller_packagelist


