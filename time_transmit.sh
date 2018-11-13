#!/bin/bash
cat cpu_mem_232|while read line
do
cpu_mem=`echo $line |awk '{print $2","$3}'`
time_date=`echo $line |awk '{print $1}'|awk -F "_" '{print $1"-"$2"-"$3" "$4":"$5":"$6}'`
echo 232 ${time_date} ${cpu_mem} >>232
done
#2017-12-14 20:42:20
