#!/bin/bash
#============ collect Mix R/w result  ========#
run_config=run_config
# find log file name into log_conf file
#grep "device$i: (groupid" -A 10|grep -v Job
parame=$1
filename=$2
filtallclient()
{
rm -rf *.log
cp base/* ./
    rm -rf log1
    mkdir log1
    for singleline in `cat $run_config`;do
        singleline1=`echo $singleline|awk -F "/" '{print $2}'`
        singleline=`ls ./ | grep $singleline| grep log`
cat $singleline|grep "device${parame}: (groupid" -A 10|grep -v Job >> ./log1/${singleline}
#cat $singleline|grep All -A 10|grep -v Job >> ./log1/${singleline}
    done
    mv log1/* ./


}
filtallclient
./resultcollect.sh
#cat result.csv |awk -F "," '{print $5","$7}' >> $filename
cat result.csv |awk -F "," '{print $5}' >> $filename

echo =========================== 
