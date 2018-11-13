#!/bin/bash
starttime=`date "+%Y_%m_%d_%H_%M_%S"`
single_sleeptime=1
cycle_sleeptime=10
cycle=3
LOGDIR=./log
FIODIR=/home/simth/fio-2.14
iostateip=`cat ./monitor_ip.conf`

collect_basic()
{
  rm -rf basicinfo
  echo starttime: $starttime >> basicinfo
  for node in `cat monitor_ip.conf`;do
    echo ============================
    echo $node basicinfo is: >> basicinfo
    ssh $node sh /home/simth/basicinfo.sh >> basicinfo
  done
  
}

run_withmulticlient()
{
# clear history log
for((i=0;i<${cycle};i++))
do
   rm -rf log$i
done


for((i=0;i<${cycle};i++));do
    ./fullfill.sh
    mkdir log${i}
    for singleline  in `cat run_config`;

    do
   kill -9 `ps -ef|grep iostat|awk '{print $2}'`
   kill -9 `ps -ef|grep sar|grep DEV| awk '{print $2}'`
   
   nohup ./collectstat.sh &
      #for singlenode in `cat cacehlist`
      #do 
       #ssh ${singlenode} echo 3 >  /proc/sys/vm/drop_caches 
      #done 
        str_cmd="${FIODIR}/fio "
        j=0
        realtime=`date "+%Y_%m_%d_%H_%M_%S"`
        str_subfix=`echo $singleline |awk -F "_" '{print $1"_"$2"_"$3"_"$4"_"$5"_"$6"_"$7"_"$8"_"$9}'`
        # Set iostat and sar monitor interval to 2 seconds, so total monitor count is duration/2
        runtime=`cat ./log/${singleline}|grep "runtime="|awk -F "=" '{print int($2)/10}'`
        warmup=`cat log/${singleline}|grep ramp_time=1|awk -F '=' '{print int($2)/10}'`
        echo warmup is $warmup ================
        runtime=$[runtime + warmup]
        echo runtime is: $runtime
      
  for k in $iostateip
                do
                    echo "Test case_log is:" log${i}/${singleline}_${realtime}.log >> /home/simth/log${i}/log_iostate_$k
                done
        nohup ./iostat_ceph.sh $runtime log${i} &

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
    cp rbdpoolstat.log log${i}/
    cp poolsize.log log${i}/
    rm -rf rbdpoolstat.log 
    rm -rf poolsize.log    
    sleep $cycle_sleeptime
done
kill -9 kill -9 `ps -ef|grep collectstat|awk '{print $2}'`

result_collet()
{
rm -rf result_tmp
mkdir result_tmp
mkdir result_tmp/base
cp log0/* result_tmp/base/
cp run_config result_tmp/  
cp pre_multiclient.sh result_tmp/
cp resultcollect.sh result_tmp/
cp total.sh result_tmp/
cd result_tmp/ 
./total.sh
cp total_result.csv ../
cd ..


}



tar -zcf ${starttime}.tar.gz basicinfo log*
}


echo cycle to run: $cycle
collect_basic
run_withmulticlient
