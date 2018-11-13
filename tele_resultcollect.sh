#!/bin/bash


run_config=run_config
# find log file name into log_conf file
filtallclient()
{
    rm -rf log1
    mkdir log1
    for singleline in `cat $run_config`;do
        singleline1=`echo $singleline|awk -F "/" '{print $2}'`
        singleline=`ls ./ | grep $singleline| grep log`
        echo $singleline
        cat $singleline|grep  All -A 10 >> ./log1/$singleline
    done
    mv log1/* ./


}






collect_conf()
{
    echo "analysis sub log directory"
    find ./log -name "*.log" >> log.temp
    rm -rf log_config
    #cat log.temp | while read singleline
    for singleline in `cat log.temp`
    do
        echo ${singleline#*/} >> log_config
    done
    for((i=1; i<13; i++));do
        cat log_config|grep "case"${i}_ >> log_config_temp
    done
    mv log_config_temp log_config
    rm -rf log.temp
    echo "create config ok"
}

create_result_first()
{
    rm -rf result.csv
    echo casename,blocksize,iodepth,imagenum,iops,read_write,latency,numjob,unit  >> result.csv
    for _logfile in `cat $run_config`
    do
        singleline=`ls ./ | grep ${_logfile} | grep log`
        latency_avg=`cat $singleline|grep -w "lat"|grep avg|awk -F "," '{print $3}'|head -n 1|awk -F "=" '{print $2}'`
        latency_unit=`cat $singleline|grep -w "lat"|grep avg|awk '{print $1$2}'|head -n 1`
        echo $latency_unit|grep "usec"
        if [ $? -eq 0 ]; then
            latency_avg1=`echo $latency_avg| awk '{print int($0)/1000}'`
            echo latency is:$latency_avg
            echo latency1 is: $latency_avg1
            latency_avg=$latency_avg1
        fi
        echo $singleline
        iops_all=`cat ${singleline}|grep "iops="`
        iops=`echo $iops_all|awk -F "," '{print $3}'| awk -F "=" '{print $2}'`
        read_write=`echo ${singleline} |awk -F "_" '{print $2$9}'`
        numberjob=`echo ${singleline} |awk -F "_" '{print $6}'`
        echo $read_write
        config_para=`echo ${singleline}|grep "config"`
        case_iodepth_image=`echo $config_para|awk -F "_" '{print $3","substr($5,8)","substr($7,9)}'`
        echo $singleline,${case_iodepth_image},${iops},$read_write,${latency_avg},${numberjob},${latency_unit}>> result.csv
    done

}


create_result_second()
{
    for _logfile in `cat $run_config`
    do
        singleline=`ls ./ | grep ${_logfile} | grep log`
        percent=`echo ${singleline}|awk -F "_" '{print $9}'| awk -F% '{print $2}'`
        if [ "${percent}" == "100" -o "${percent}" == "0"  ]
        then
            continue
        fi
        value_found=`cat $singleline|grep -w "lat"|grep -v "%"`
        echo $value_found
        latency_avg2=`echo $value_found|awk -F "," '{print $6}'| awk -F "=" '{print $2}'`
        latency_unit2=`echo $value_found|awk -F "," '{print $4}'|awk '{print $2$3}'`
        echo $latency_unit2|grep "usec"
        if [ $? -eq 0 ]; then
            latency_avg_msec=`echo $latency_avg2| awk '{print int($0)/1000}'`
            echo latency is:$latency_avg2
            echo latency1 is: $latency_avg_msec
            latency_avg2=$latency_avg_msec
        fi
        read_write=`echo ${singleline} |awk -F "_" '{print $2}'`
        numberjob=`echo ${singleline} |awk -F "_" '{print $6}'`
        echo $singleline
        iops_all=`cat ${singleline}|grep  "iops="`
        echo $iops_all
        read_write=`echo ${singleline}|awk -F "_" '{print $2}'`
        iops_2=`echo $iops_all|awk -F "," '{print $6}'| awk -F "=" '{print $2}'`
        echo ===== $iops2
        config_para=`echo ${singleline}|grep -E "config"`
        echo $iops_2     
        case_iodepth_image=`echo $config_para|awk -F "_" '{print $3","substr($5,8)","substr($7,9)}'`
        echo $singleline,${case_iodepth_image},${iops_2},30$read_write,${latency_avg2},${numberjob},${latency_unit2}>> result.csv
    done
}


filtallclient()
{
    rm -rf log1
    mkdir log1
    for singleline in `cat $run_config`;do
        singleline1=`echo $singleline|awk -F "/" '{print $2}'`
        singleline=`ls ./ | grep $singleline| grep log`
        echo $singleline
        cat $singleline|grep  All -A 10 >> ./log1/$singleline
    done
    mv log1/* ./


}

filtallclient
#collect_conf
sleep 2
create_result_first
create_result_second

