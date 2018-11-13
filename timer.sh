#!/bin/bash
#start task
echo original crontab is:
crontab -l
get_crontab_task()
{
  rm -rf temp_crontab.log
  rm -rf timer.conf
  crontab -l > temp_crontab.log
}

set_crontab_task()
{
cat temp_crontab.log|grep simth|grep ceph_s   > /dev/null 2>&1
if [ $? -ne 0 ];then
  echo "*/1 * * * * /home/simth/ceph_s.sh" >> temp_crontab.log
  echo "*/1 * * * * /home/simth/check_cpu_mem.sh" >> temp_crontab.log
fi
crontab /home/simth/temp_crontab.log

echo current crontab is: 
crontab -l
}


get_crontab_task
set_crontab_task
