#!/bin/bash

current_date=`date "+%Y_%m_%d_%H_%M_%S"`
numjob=(1 4 8)
image_count=(8)
iodepth=(1 4 8 16)
runtime=180
rbdpara="rbd"
rw="rw"
rwmixread="100"
bs="1024k"
case_num=$1

generate()
{
    rm -rf log/
    mkdir -p log
    for i in "${!numjob[@]}"; do
        for j in "${!iodepth[@]}";do
            single_iodepth=${iodepth[$j]}
            for k in "${!image_count[@]}";do
                ./case.sh $rbdpara $rw $bs $runtime ${iodepth[$j]} ${numjob[$i]} ${image_count[$k]} $current_date ${rwmixread} ${case_num}
            done
        done
    done
    ls -l ./log|grep config|awk '{print $9}' >> run_config_${rbdpara}_${current_date}
    cp run_config_${rbdpara}_${current_date} ./run_config
}

generate $1

