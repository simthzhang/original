#!/bin/bash

single_sleeptime=1
cycle_sleeptime=10
cycle=2
LOGDIR=./log
FIODIR=/home/simth/fio-2.14/
iostateip=`cat ./cluster_ip.conf`

run_withmulticlient()
{
    for((i=0;i<${cycle};i++));do
        rm -rf log${i}
        mkdir log${i}
        for singleline  in `cat run_config_1_6`;
        do
            str_cmd="${FIODIR}/fio "
            j=0
            realtime=`date "+%Y_%m_%d_%H_%M_%S"`
            str_subfix=`echo $singleline |awk -F "_" '{print $1"_"$2"_"$3"_"$4"_"$5"_"$6"_"$7"_"$8"_"$9}'`
               for k in $iostateip
                do
                    echo "Test case_log is:" log${i}/${singleline}_${realtime}.log >> /home/simth/log${i}/log_iostate_$k
                done
                nohup ./iostat_ceph.sh 120 log${i} &

            for fioserver in `cat fioserver_list.conf`
            do
                str_client="--client $fioserver ${LOGDIR}/${str_subfix}_${j}.config"
                str_cmd="${str_cmd} ${str_client}"
                j=$[j+1]
            done
            echo command is: $str_cmd
            $str_cmd |tee  log${i}/${singleline}_${realtime}.log
            echo ===================================
            sleep $single_sleeptime
        done
        cp run_config log${i}/
        sleep $cycle_sleeptime
    done
}
run_withmulticlient
