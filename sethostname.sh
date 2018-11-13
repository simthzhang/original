#!/bin/bash
controllername=controller
num=0
rm -rf hostinfo
#以下是管理网的虚ip
vip_a="2009:20c:20c:20c:20c:29ff:0:94 api.inte.lenovo.com"
vip_b="2009:20c:20c:20c:20c:29ff:0:94 controller"
#192.168.100.106 api.inte.lenovo.com
#192.168.100.106 controller
main() 
{
#Generate_config $pool $rw $bs $runtime $iodepth $numjobs $image_num
for controller in `cat controller_list`;do
    num=`expr ${num} + 1`
    ssh  $controller hostnamectl set-hostname controller-$num
    ssh  $controller iptables -F && iptables -X & setenforce 0
    echo ============================ >> hostinfo
    ssh $controller    cat /etc/hosts|grep "localdomain4$"
      if [ $? -eq 0 ];then
      ssh $controller sed -i "s/127.0.0.1\ \ \ localhost\ localhost.localdomain\ localhost4\ localhost4.localdomain4/127.0.0.1\ \ \ localhost\ localhost.localdomain\ localhost4\ localhost4.localdomain4\ controller-"$num"/g" /etc/hosts
      ssh $controller sed -i "s/::1\ \ \ \ \ \ \ \ \ localhost\ localhost.localdomain\ localhost6\ localhost6.localdomain6/::1\ \ \ \ \ \ \ \ \ localhost\ localhost.localdomain\ localhost6\ localhost6.localdomain6\ controller-"$num"/g" /etc/hosts
#127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 controller-1
#::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 controller-1 
fi
    echo controller is $controller 
    echo controller-$num >> hostinfo
    ssh  $controller ip a|grep -E "2009|2008" >> hostinfo
    echo setting controller-$controller hostname
    nodename=`ssh  $controller hostname`
    echo hostname set is $controller $nodename
done
for controller in `cat controller_list`
    do
    echo controller is ==== $controller
    ssh  $controller "echo $vip_a >>  /etc/hosts"
    ssh  $controller "echo $vip_b >> /etc/hosts"
   # ssh  $controller cat  /etc/hosts

done
}
main

