#!/bin/bash
mount_dir=/mnt/simth

copyfile()
{
    for((j=0;j<10;j++))
    do
        for((i=0;i<10;i++))
        do
            echo 3 >  /proc/sys/vm/drop_caches
            current_date=`date "+%Y_%m_%d_%H_%M_%S"`
            rm -rf /mnt/simth/deployment-standalone-daily_20180314_11_py.tar.gz
            cp /home/simth/deployment-standalone-daily_20180314_11_py.tar.gz /mnt/simth/${j}${i}.tar.gz
            cd /mnt/simth/
            tar -zxf /mnt/simth/${j}${i}.tar.gz
            md5sum ${mount_dir}/deployment/standalone-setup.sh ${mount_dir}/test/standalone-setup.sh >>${j}.log
            echo testingsimth${i} >> /mnt/simth/deployment/standalone-setup.sh
            cat deployment-standalone-daily_20180314_11_py.tar.gz1 >> /mnt/simth/deployment/standalone-setup.sh
            ls -l /mnt/simth/test/standalone-setup.sh
            ls -l /mnt/simth/deployment/standalone-setup.sh
            md5sum ${mount_dir}/deployment/standalone-setup.sh >> ${j}.log
            rm -rf ${j}${i}.tar.gz
            rm -rf /mnt/simth/deployment/
            echo $current_date >> ${j}.log
            echo $j $i  >> ${j}.log
            echo =====================================================
        done
    done

}

copyfile

