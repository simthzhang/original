#!/bin/bash
while true 
do
for i in `cat fioserver_list1.conf`; do ping -c 1  $i|grep icmp;done
echo ==========================
sleep 10

done
