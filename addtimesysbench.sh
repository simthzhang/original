#!/bin/bash
rm -rf timchang
for i in `cat time1`
do
time1=`echo  $i|awk -F "_" '{print $3}'`
time2=`echo $time1|awk -F "-" '{print $1"-"$2"-"$3" "$4}' `
echo $time2
for j in `cat $i|awk '{print $2}'|grep thds |awk '{sub(/.$/,"")}1'`;do ./1.sh "${time2}" ${j} >> timchang;done
done
