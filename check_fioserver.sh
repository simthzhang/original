#!/bin/bash

check_fioserver()
{
    for i in `cat fioserver_list.conf`;do
        process_id=`ssh $i ps -ef|grep fio|grep server|grep -v check|grep -v ssh|awk '{print $2}'`
        echo ======${i}=========
        echo process is: $process_id
    	#ssh ${fio_server_ip[$k]} kill -9 $process_id
        #ssh $i nohup /home/simth/fio-2.14/fio-2.14/fio --server &
    done

}
check_fioserver

