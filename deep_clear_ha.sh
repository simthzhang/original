#!/usr/bin/bash

disable_service()
{
        echo  ">>> disable services ..."

        for service_need in mariadb storagemgmt sds-agent keystone crm_mon corosync haproxy ceph pacemaker rabbit
        do
		echo "... ${service_need}"
		systemctl stop $(systemctl list-units | grep ${service_need} | awk '{print $1}')
        	systemctl disable $(systemctl -a | grep ${service_need} | awk '{print $1}')
		kill -9 $(ps -ef | grep ${service_need} | awk '{print $2}')
        done

}
remove_package()
{
        echo  ">>> remove packages ..."
        for rm_need in resource-agents pacemaker corosync crmsh crmsh-scripts inotify-tools haproxy galera mariadb mariadb-config f2fs_tools rados rbd ceph rabbit

        do
		for rpm_name in $(rpm -qa | grep ${rm_need})
		do
                	echo "... ${rpm_name}"
			yum remove ${rpm_name} -y
			rpm ${rpm_name} -e --nodeps
		done
        done
}

remove_config_file()
{
	echo ">>> remove conifg files ..."
	rm -rf /tmp/ha_config_files.bak
        mkdir -p /tmp/ha_config_files.bak/lib
        mkdir -p /tmp/ha_config_files.bak/ocf
        mkdir -p /tmp/ha_config_files.bak/share

	for dir_name in ceph corosync-qdevice corosync-qnetd crm_mon haproxy mariadb
	do
		mv /etc/sysconfig/${dir_name} /tmp/ha_config_files.bak/ -f
		mv /etc/systemd/system/${dir_name}.service* /tmp/ha_config_files.bak/ -f
		mv /usr/lib/systemd/system/${dir_name}.service /tmp/ha_config_files.bak/ -f
	done

	for dir_name in corosync pacemaker crmsh inotify-tools galera ceph storagemgmt storagemgmt_cron haproxya mariadb mysql rabbit
	do
		mv /etc/${dir_name} /tmp/ha_config_files.bak/ -f
		mv /usr/sbin/${dir_name}* /tmp/ha_config_files.bak/ -f
		mv /usr/share/${dir_name} /tmp/ha_config_files.bak/share/ -f
		mv /var/lib/${dir_name} /tmp/ha_config_files.bak/lib/ -f
	done
	mv /etc/my.cnf.d/galera.cnf /tmp/ha_config_files.bak/ -f
	mv /etc/my.cnf.d/mariadb-server.cnf /tmp/ha_config_files.bak/ -f
	mv /etc/my.cnf.d/mysql-clients.cnf /tmp/ha_config_files.bak/ -f
	mv /var/run/mysqld /tmp/ha_config_files.bak/ -f
	mv /usr/lib/ocf/* /tmp/ha_config_files.bak/ocf -f
	mkdir -p /usr/lib/ocf/lib/heartbeat
}
clear_yum()
{
	yum clean all
        yum-complete-transaction --cleanup-only
}


disable_service
remove_package
remove_config_file
clear_yum
