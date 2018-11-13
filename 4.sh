vdbench_clientlist=(192.168.209.221 192.168.209.222 192.168.209.223)
  for k in "${!vdbench_clientlist[@]}";do
   ssh ${vdbench_clientlist[$k]} rm -rf /mnt/sdb/1
   ssh ${vdbench_clientlist[$k]} rm -rf /mnt/sdc/1
   ssh ${vdbench_clientlist[$k]} rm -rf /mnt/sdd/1
   ssh ${vdbench_clientlist[$k]} ls -l /mnt/sd*/
  done

