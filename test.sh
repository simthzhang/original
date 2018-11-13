#!/bin/bash
rm -rf *.tmp
for logfile in `cat run_config`
do
echo $logfile
for ((i=0;i<51;i++))
do
   singleline=`ls ./  | grep $logfile | grep log` 
  # echo ==========$singleline
cat $singleline|grep "device$i: (groupid" -A 10|grep -v Job >> ${singleline}_device${i}.tmp
done   
 done

