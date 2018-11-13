#!/bin/bash
image_size=10G
image_count=150
image_begin=0
image_pool=rbd
image_name=testimage_${image_size}
endtime=`date "+%Y_%m_%d_%H_%M_%S"`
source /root/localrc
createimage()
{
    
     create_starttime=` echo $[$(date +%s%N)/1000000]`
     echo create_starttime is $create_starttime
     for ((i=${image_begin};i<${image_count};i++))
     do
     #rbd create ${image_name}B_$i --image-format 2 --size ${image_size} --pool $image_pool
     rbd create testimage_10GB_$i --image-format 2 --size ${image_size} --pool $image_pool
     done
     #cephmgmtclient create-rbd --cluster_id 1 --pool_id 5 --name simth --capacity 10737418240 --num 1 --shared 0 
     #cephmgmtclient create-rbd --cluster_id 2 --pool_id 5 --name $image_name  --capacity $image_size --num $image_count --object_size 4 --shared 0
     #cephmgmtclient create-rbd --cluster_id 1 --pool_id 2 --name ${image_name}B_${i} --capacity 10240 --num 1 --object_size 4
#    rbd info -p $image_pool --image ${image_name}B_$i
     create_endtime=` echo $[$(date +%s%N)/1000000]`
     echo create_endtime is $create_endtime
     reduce=`expr ${create_endtime} - ${create_starttime}`
     echo duration ${reduce}ms
}

deleteimage()
{
echo =====================
     delete_starttime=` echo $[$(date +%s%N)/1000000]`
     echo delete_starttime is $delete_starttime
     for ((i=${image_begin};i<${image_count};i++))
         do
     #       rbd rm -p $image_pool ${image_name}-$i
           echo rbdimage to delete is ${image_name}_$i
            rbd rm -p $image_pool ${image_name}B_$i
            #cephmgmtclient delete-rbd --cluster_id 1 --pool_id 2 --rbd_id 41
         done
     delete_endtime=` echo $[$(date +%s%N)/1000000]`
     echo delete_endtime is $delete_endtime
     reduce=`expr ${delete_endtime} - ${delete_starttime}`
     echo delete duration ${reduce}ms

}


total_starttime=` echo $[$(date +%s%N)/1000000]`

createimage
echo =========sleep 3 seconds
sleep 3
echo ==============================
echo rbd image in pool  $image_pool: 
rbd -p $image_pool ls
deleteimage
total_endtime=` echo $[$(date +%s%N)/1000000]`

reduce=`expr ${total_endtime} - ${total_starttime}`
echo =============================
echo total duration  ${reduce}ms

