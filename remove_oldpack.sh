#!/bin/bash
check_pac()
{
		rm -rf rpm.list
        rpm -qa ctdb >> rpm.list
        rpm -qa libtdb >> rpm.list
        rpm -qa samba-client-libs >> rpm.list
        rpm -qa samba-common  >> rpm.list
        rpm -qa libwbclient >> rpm.list
        rpm -qa tdb-tools >> rpm.list
		cat rpm.list
}
remove_pac()
{
		for i in `cat rpm.list`
			  do
					  rpm -e $i --nodeps
			  done

}

check_pac
#remove_pac
#check_pac
#samba-client-libs-4.4.4-9.el7.x86_64
#check_pac
#kill -9 `ps -ef|grep ctdb|awk '{print $2}'`
#/etc/ceph/scripts/clear.sh



