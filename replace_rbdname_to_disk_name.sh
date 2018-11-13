#!/bin/bash
step=$1


generate_disklist()
{ 
    rm *_disk
    rm -rf *_tmp
    for i in `cat ceph_ip.conf`
    do
       boot=`ssh $i lsblk|grep boot`        
        ssh $i lsblk|grep -E -v "NAME|swap|part|lvm"|awk '{print $1}' >> ${i}_tmp
        for j in `cat ${i}_tmp`
        do
          echo $boot|grep $j >> /dev/null
          if [ $? -eq 1 ];then
          echo $j >> ${i}_disk
          fi
        done 
    done
    
      for i in `cat ceph_ip.conf`
    do
       echo =================================
        echo server $i data disk is 
        for j in `cat ${i}_disk|awk '{print $1}'`
        do
         echo /dev/$j
       done
    done
}

replace()
{
if [ -z "$1" ]; then
    echo "imagecount is empty!"
    echo Sample: "./disk_replace.sh <imagenumber>"
    exit
fi

    number=0
    confignum=0
    number1=0
    for i in `cat ceph_ip.conf`
    do 
        echo disk number is $number
        number=`expr $number \* $step` 
        for j in `cat ${i}_disk|awk '{print $1}'`
        do
            disk=${j}
            disk="\/dev\/${disk}"
            echo change [device${number1}]testimage_100GB_${number1} to   $disk
            testimage=testimage_100GB_${number1}
            sed -i 's/'"$testimage"'/'"$disk"'/g' log/*_${confignum}.config
            number1=$(($number1+1))
        done
        #echo confignum is $confignum
        number=$(($number+1))
        confignum=$(($confignum+1))
    done
    echo device count is $number1
#echo "You need change device name to /dev/sdxx by using replace_rbdname_to_disk_name.sh!!!!!!!!!!!!!!!!!!!"
###
#prepare result collect write number to result collect script
orignal=`cat ./total.sh|grep  total_device_count=`
orignal=$orignal
echo change result collect rawnumber $raw_num
target="total_device_count=${number1}"
echo ori target $orignal $target
#sed -i''"${raw_nums}"'/^.*$/'"${to_replace}"'' ./total.sh
sed -i 's/'"$orignal"'/'"$target"'/g' ./total.sh

#sed '3s/^*$/total_device_count=7/' ./total.sh

}
generate_disklist
replace $1

