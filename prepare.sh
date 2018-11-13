#!/bin/bash
cluster_ip=`cat ./monitor_ip.conf`

copy_key()
{
    for i in $cluster_ip
    do
        ssh-copy-id  $i
    done
}
makedir()
{
    for i in $cluster_ip; do
        echo hostip is: $i
        ssh $i mkdir -p /home/simth
    done
    echo list /home/simth
    for i in $cluster_ip; do
        ssh $cluster_ip ls /home/
    done

}

listdir()
{
    for i in $cluster_ip; do
        echo hostip is: $i
        ssh $i ls /home/simth
        ssh $i hostname
    done

}

copyfio()
{
    for i in $cluster_ip; do
        echo hostip is: $i
        scp  /home/simth/fio-2.14.tar.gz $i:/home/simth/
        ssh $i tar -zxvf /home/simth/fio-2.14.tar.gz -C /home/simth
    done

}



copyconfig()
{
#rm ./log.tar.gz
#tar -zcf log.tar.gz ./log/
#configfile=$1
#echo $configfile
for i in $cluster_ip; do
    echo hostip is: $i
    #copy config and script
    scp *.sh $i:/home/simth
done

}

exec_fio()
{
    for i in $cluster_ip; do
        echo hostip is: $i
        ssh $i  /home/simth/run.sh   
    done
}

main()
{
copy_key
makedir
copyfio
copyconfig 
listdir

}
main
