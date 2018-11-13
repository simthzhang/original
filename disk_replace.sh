#!/bin/bash
step=7

generate_disklist()
{ 
    rm *_disk
    for i in `cat ceph_ip.conf`
    do
        ssh $i lsblk|grep -v swap |grep -v "/">> ${i}_disk
    done
}

replace()
{
    number=0
    confignum=0
    number1=0
    for i in `cat ceph_ip.conf`
    do 
        echo number is $number
        number=`expr $number \* $step` 
        for j in `cat ${i}_disk|awk '{print $1}'`
        do
            disk=${j}
            echo disk is $disk
            disk="\/dev\/${disk}"
            echo  disk is $disk
            echo number1 is $number1
            testimage=testimage_100GB_${number1}
            sed -i 's/'"$testimage"'/'"$disk"'/g' log/*_${confignum}.config
            number1=$(($number1+1))
        done
        number=$(($number+1))
        confignum=$(($confignum+1))
        echo confignum is $confignum
    done

}
#generate_disklist
replace

