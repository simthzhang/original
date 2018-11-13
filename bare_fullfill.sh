

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

