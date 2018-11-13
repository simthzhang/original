#!/bin/bash

start_fioserver()
{
    server_ips=`cat ./fioserver_list.conf`
    for i in $server_ips
    do  
        ssh $i echo `hostname`
        ssh $i nohup /home/simth/fio-2.14/fio --server &
    done
}
start_fioserver
