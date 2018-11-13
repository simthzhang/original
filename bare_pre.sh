#!/bin/bash
#============ collect Mix R/w result  ========#
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
filtallclient
