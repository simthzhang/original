#!/bin/bash


current_date=$8
log_dir=./log
sh_dir=./
pool=$1
rw=$2
bs=$3
runtime=$4
iodepth=$5
numjobs=$6
image_num=$7
direct=1
case_num=${10}
percentage=${9}
fioserver_num=0

generate_config() 
{
        mkdir -p $log_dir
        config_para=$1
        num=`echo $config_para|awk -F "_" '{print $10}'`
        config_filename=${config_para}.config
        echo "[global]" >> $log_dir/$config_filename
        echo ioengine=rbd >> $log_dir/$config_filename
        echo clientname=admin >> $log_dir/$config_filename
        echo pool=$pool >> $log_dir/$config_filename
        echo rw=$rw >> $log_dir/$config_filename
        echo bs=$bs >> $log_dir/$config_filename
        echo runtime=$runtime >> $log_dir/$config_filename
        echo time_based=1 >> $log_dir/$config_filename
        echo ramp_time=10 >> $log_dir/$config_filename
        echo iodepth=$iodepth >> $log_dir/$config_filename
        echo numjobs=$numjobs >> $log_dir/$config_filename
        echo direct=$direct >> $log_dir/$config_filename
        echo rwmixread=${percentage} >> $log_dir/$config_filename
        echo new_group >> $log_dir/$config_filename
        echo group_reporting >> $log_dir/$config_filename
        sh ./fill_image.sh $log_dir $image_num $config_filename $num

}


main() 
{
#Generate_config $pool $rw $bs $runtime $iodepth $numjobs $image_num
for i in `cat fioserver_list.conf`;do
    config_para=${pool}_${rw}_${bs}_runtime${runtime}_iodepth${iodepth}_numjob${numjobs}_imagenum${image_num}_${case_num}_%${percentage}_${fioserver_num}
    fioserver_num=`expr ${fioserver_num} + 1`
    generate_config $config_para
done
}
main
