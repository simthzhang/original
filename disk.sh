#!/bin/bash
io_depth=(1 8)
disk_list=(sdc sdg sdh sdi)
test_dir=/home/simth/
run_time=180
ceph_hostname=`hostname`
current_time=`date "+%Y%m%d_%H%M%S"`
file_size=1G


randwrite()
{
for i in "${!io_depth[@]}"; do
 for j in "${!disk_list[@]}"
     do
        echo ${disk_list[$j]} 
        echo ${io_depth[$i]}
        file_name=hostname_${ceph_hostname}_disk_${disk_list[$j]}_iodepth_${io_depth[$i]}_${current_time}
        nohup ./fio-2.14/fio-2.14/fio -filename=/dev/${disk_list[$j]} --ioengine=libaio --iodepth=${io_depth[$i]} -direct=1 -rw=randwrite -bs=8k -size=${file_size} -numjobs=1 -group_reporting -runtime=${run_time} -name=test2 |tee ${file_name}_8k_randwrite_${file_size}.log &
        sleep 250
     done
done

}
randread()
{
for i in "${!io_depth[@]}"; do
   for j in "${!disk_list[@]}"
     do
        echo ${disk_list[$j]} 
        echo ${io_depth[$i]}
        file_name=hostname_${ceph_hostname}_disk_${disk_list[$j]}_iodepth_${io_depth[$i]}_${current_time}
        nohup ./fio-2.14/fio-2.14/fio -filename=/dev/${disk_list[$j]} --ioengine=libaio --iodepth=${io_depth[$i]} -direct=1 -rw=randread -bs=8k -size=${file_size} -numjobs=1 -group_reporting -runtime=${run_time} -name=test2 |tee ${file_name}_8k_randread_${file_size}.log &
        sleep 250
    done
done
}



randwrite
