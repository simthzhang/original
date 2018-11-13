#!/bin/sh

ftpserverip=10.110.133.169
dir_name=/tmp/ceph_log
localdir=/tmp/localdir/
coreid="231783"
ceph_nodeip=(192.168.123.116 192.168.123.117 192.168.123.118)
client_nodeip=(vm-client1 vm-client2 vm-client3 vm-client4)
LEN=${#ceph_nodeip[@]}
LEN_CLIENT=${#client_nodeip[@]}

upload()
{
ftp -v -n ${ftpserverip}<<EOF
user simth testing123
binary
lcd ${localdir}/
prompt
mput *
bye
#here document
EOF
echo "commit to ftp successfully"
}

exec_collectcephlog()
{
for ((i=0; i<${LEN}; i++))
  do
    ip=${ceph_nodeip[${i}]}
    scp collect_cephlog.sh $ip:/root/
    nohup ssh $ip /root/collect_cephlog.sh &
done
wait
for ((i=0; i<${LEN}; i++))
  do
    ip=${ceph_nodeip[${i}]}
    scp -r  ${ip}:${dir_name}/ceph/* $localdir
done
}
exec_collectclientlog()
{

for ((i=1; i<5; i++))
  do
    ip=${client_nodeip[${i}]}
    echo client ip is $ip
    scp collect_clientlog.sh $ip:/root/
    nohup ssh $ip /root/collect_clientlog.sh  &
done
wait
for ((i=1; i<5; i++))
  do
    echo client ip is $ip
    ip=${client_nodeip[${i}]}
    scp -r  ${ip}:${dir_name}/bussinesslog/* $localdir
done
}
#rm -rf $localdir
#mkdir $localdir
#exec_collectcephlog 
#exec_collectclientlog
upload
