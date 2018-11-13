#!/bin/bash

stop_fioserver()
{
    for i in `cat fioserver_list.conf`;do
        process_id=`ssh ${i} ps -ef|grep fio|grep server|grep -v stop_fi|awk '{print $2}'`
        echo $process_id
        ssh ${i} kill -9 $process_id
    done   
}
stop_fioserver
./check_fioserver.sh
