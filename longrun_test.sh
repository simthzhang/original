#!/bin/bash
queue_depth=(1024 512)
#queue_depth=(1024 512 256 128 64 32)
timeout=(1 5)

 for i in "${!queue_depth[@]}";do
   for j in "${!timeout[@]}";do
  echo ${timeout[$j]} 128 ${queue_depth[$i]}
  /home/simth/filterdevice.sh ${timeout[$j]} 128 ${queue_depth[$i]}
  ./rbd.sh
   cat /home/simth/log*/vdb*/err*
   echo ===========================================
   done
 done

