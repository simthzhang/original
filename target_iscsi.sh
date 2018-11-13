#!/bin/bash
tid=$1
tid_group=(1 2 3)
lun=1
poolname=rbd
rbdname=testimage_100GB_2
targetname=iqn.2018-11.com.lenovo:target$1
initator_ip="2008:20c:20c:20c:20c:29ff:0:60"
target_ip="2008:20c:20c:20c:20c:29ff:0:61"
create_iscsi_withchap()
{
#create_iscsi
tgtadm --lld iscsi --mode target --op new --tid ${tid} -T ${targetname}
#bind_iscsi_with rbd
tgtadm --lld iscsi --mode logicalunit --op new --tid ${tid} --lun ${lun} --bstype rbd --backing-store ${poolname}/${rbdname} --bsopts "conf=/etc/ceph/ceph.conf"
#give access to initator
tgtadm  --lld iscsi --mode target --op bind --tid ${tid} -I ${initator_ip}
#create_account
tgtadm --lld iscsi --mode account --op new --user admin --password admin123456
#bind target_to_account
tgtadm --lld iscsi --mode account --op bind --user admin --tid ${tid}
#show_iscsi
tgtadm --lld iscsi --op show --mode target
}
show_iscsi()
{
tgtadm --lld iscsi --op show --mode target
}

unbind_iscsi_withrbd()
{

    for i in "${!tid[@]}"
         do
               tgtadm --lld iscsi -- p delete --mode=logicalunit --tid=${tid[$i]} --lun=${lun}
        done

}
delete_iscsi()
{
 for i in "${!tid_group[@]}" 
         do
               tgtadm --lld iscsi --mode target --op delete --tid ${tid_group[$i]} 
        done

}
###################################################################
#initator action
#也可以在/etc/iscsi/iscsi.conf 里静态配置
#node.session.auth.authmethod = CHAP
# To set a CHAP username and password for initiator
# authentication by the target(s), uncomment the following lines:
#node.session.auth.username = admin
#node.session.auth.password = admin123456
###################################################################
chap_auth()
{
iscsiadm --mode node -T ${targetname} -p ${target_ip} -o update --name node.session.auth.authmethod --value CHAP
#设置target用户名密码（对应target的account）：需要initator端提供的账号, 用来认证initator
iscsiadm --mode node -T ${targetname} -p ${target_ip} -o update --name node.session.auth.username --value admin
iscsiadm --mode node -T ${targetname} -p ${target_ip} -o update --name node.session.auth.password --value admin123456
#设置initiator用户名密码（对应target的outgoing account）：需要target端提供的账号, 用来认证target
#login
#iscsiadm --mode node -T iqn.2017-04.com.lenovo:devsdb -p 127.0.0.1 -o update --name node.session.auth.username_in --value admin1
#iscsiadm --mode node -T iqn.2017-04.com.lenovo:devsdb -p 127.0.0.1 -o update --name node.session.auth.password_in --value admin123456
}


#create_iscsi_withchap
#chap_auth
#unbind_iscsi_withrbd
show_iscsi
delete_iscsi
