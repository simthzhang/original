#!/bin/bash
current_date=`date "+%Y_%m_%d_%H_%M_%S"`

for((i=0;i<40000;i++));do
current_date=`date "+%Y_%m_%d_%H_%M_%S"`
echo $current_date
sleep 1
done
