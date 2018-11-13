#!/bin/bash
io_depth=(1024)
disk_list=(sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm)
test_dir=/home/simth/
run_time=5
ceph_hostname=`hostname`
current_time=`date "+%Y%m%d_%H%M%S"`
flash_ssd()
{

for j in "${!disk_list[@]}"
     do
        echo ${disk_list[$j]} 
        file_name=hostname_${ceph_hostname}_flashdisk_${disk_list[$j]}_iodepth_${io_depth[$i]}_${current_time}
      nohup ./fio-2.14/fio -filename=/dev/${disk_list[$j]} --ioengine=libaio --iodepth=1024  -direct=1 -rw=write -bs=1M  -numjobs=1 -group_reporting -name=test2 |tee ${file_name}_flashfull.log &

    done

}
flash_ssd