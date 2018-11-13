#!/bin/bash
#Fullfill below value to 
initatorip=(192.168.208.221 192.168.208.222 192.168.208.223 192.168.208.224)
targetip=(192.168.208.121 192.168.208.228 192.168.208.123)
targetname=(taget1 target2 target3 target4 target5 target6 target7 target8)


copy_key()
{
    for i in "${!initatorip[@]}";do
        single_ip=${initatorip[$i]}
        echo please input iscsi initator ${single_ip} login phase:
        ssh-copy-id  $single_ip
    done

}


installiscis()
{
       for j in "${!initatorip[@]}";do
           single_initatorip=${initatorip[$j]}
           scp ./*.rpm $single_initatorip:/tmp
           ssh $single_initatorip   rpm -ivh /tmp/device-mapper-multipath-libs-0.4.9-99.el7_3.3.x86_64.rpm
           ssh $single_initatorip   rpm -ivh /tmp/kpartx-0.4.9-99.el7_3.3.x86_64.rpm
           ssh $single_initatorip   rpm -ivh /tmp/device-mapper-multipath-0.4.9-99.el7_3.3.x86_64.rpm --nodeps
           ssh $single_initatorip   rpm -ivh /tmp/iscsi-initiator-utils-iscsiuio-6.2.0.873-35.el7.x86_64.rpm --nodeps
           ssh $single_initatorip   rpm -ivh /tmp/iscsi-initiator-utils-6.2.0.873-35.el7.x86_64.rpm
       done


}

discovery()

{
    rm -rf iscsilist.config
    for j in "${!initatorip[@]}";do
        echo =============================================
        echo Target in Initator ${initatorip[$j]}  are:
        single_initatorip=${initatorip[$j]}
        scp multipath.conf $single_initatorip:/etc/
        ssh $single_initatorip modprobe dm-multipath
        ssh $single_initatorip modprobe dm-round-robin 
        ssh $single_initatorip service multipathd start
        ssh $single_initatorip multipath -F
        ssh $single_initatorip multipath -v2
        
        
        for i in "${!targetip[@]}";do
            target_singleip=${targetip[$i]}
            echo ssh $single_initatorip iscsiadm -m discovery -t st -p $target_singleip
            ssh $single_initatorip iscsiadm -m discovery -t st -p $target_singleip > tmp.log
            if [ "$?" -eq 0  ]; then
                sed -i 's/ /,/g' tmp.log
                for k in `cat tmp.log`
                do
		    for l in "${!targetname[@]}"
 	              do
			echo $k  ${targetname[$l]} -----------
		    	echo $k|grep -w ${targetname[$l]}
                        if [ "$?" -eq 0  ]; then
                    	echo $single_initatorip,$k >> iscsilist.config
			fi
                      done
                done
            fi
        done
    done

}

login_outaction()
{
    login_out=$1
    for loginitem in `cat iscsilist.config`
    do
        initatorip=`echo $loginitem|awk -F "," '{print $1}'`
        echo initatorip is: $initatorip
        targetip=`echo $loginitem|awk -F "," '{print $2}'|awk -F ":" '{print $1}'`
        echo targetip is: $targetip
        targetname=`echo $loginitem|awk -F "," '{print $4}'`
        echo targetname is: $targetname
        echo =====================================
        ssh $initatorip lsblk
        ssh $initatorip  iscsiadm -m node -T $targetname  -p $targetip --$login_out
        ssh $initatorip lsblk
    done

}

#copy_key
#installiscis
#discovery
login_outaction login

