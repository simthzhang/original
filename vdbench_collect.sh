#!/bin/bash
cycle=48
vdbenchcase=`cat run_config`
rm -rf result
mkdir result 
#case count
for((i=1;i<2;i++));do
    #cycle value
    for((j=0;j<${cycle};j++));do
        rm -rf  log${j}/${vdbenchcase}_dir/summary.log
        cat log${j}/${vdbenchcase}_dir/summary.html| while read line
        #cat ./output/summary.html| while read line
    do
        echo $line |grep interval >> /dev/null
        if [ $? -eq 0 ];then
            current_year=`echo ${line}|awk '{print $3}'`
            time_stamp=`echo ${line}|awk -F "," '{print $1}'|awk '{print $2"/"$1}'`
            echo $time_stamp
            time_stamp=${time_stamp}/$current_year
            temp_date=`echo "$time_stamp" | sed 's/\// /g' | sed 's/:/ /'`
            date_toadd=`date -d "$temp_date" '+%Y-%m-%d'`
        else
            echo $date_toadd $line >> log${j}/${vdbenchcase}_dir/summary.log
            #echo $date_toadd $line >> ./output/summary.log
        fi
    done 
done
done
collect()
{
    rm -rf result
    mkdir result
    for((i=1;i<2;i++));do
        echo date  interval        i/o   MB/sec   bytes   read     resp     read    write     resp     resp queue  cpu%  cpu% >>result/result${j}.log
        echo test  test            rate  1024**2     i/o    pct     time     resp     resp      max   stddev depth sys+u   sys >> result/result${j}.log
        for((j=0;j<${cycle};j++));do
          cat log${j}/${vdbenchcase}_dir/summary.log |grep -w "[0-9]" |grep -E -v "sys|avg|maxdata" >> result/result${j}.log
         #cat log${j}/${vdbenchcase}_dir/summary.html|grep tar.gz >> result/result${i}.log
        done
    done
}
rm -rf /home/simth/result/*
collect
for ((i=0;i<${cycle};i++));do cat result/result${i}.log>> ./result/summary.log;done
