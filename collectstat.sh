#!/bin/bash
#ecpoolstat=`ceph osd pool stats ecpool`
starttime=`date "+%Y_%m_%d_%H_%M_%S"`
cache_pool=rbd
storage_pool=ec_rbd
collectpoolstat()
{
  rbdpoolstat=`ceph osd pool stats ${cache_pool}`
  ecpoolstat=`ceph osd pool stats ${storage_pool}`
  echo $starttime $rbdpoolstat >> rbdpoolstat.log
  echo $starttime $ecpoolstat >> rbdpoolstat.log
}
collectpoolsize()
{
 rbdsize=`ceph df |grep ${cache_pool}`
 ecsize=`ceph df |grep ${storage_pool}`
 echo $starttime $rbdsize $ecsize >> poolsize.log
}

while true
do
collectpoolstat
collectpoolsize
sleep 1
done
