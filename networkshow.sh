#!/bin/bash
for temp in `neutron net-list --all-tenant |grep rally|awk -F "|" '{print $2}'`
do
neutron net-show $temp
#echo ====$temp
#neutron dhcp-agent-list-hosting-net $temp
done
#while (true)
#do
#neutron net-list|grep rally|wc -l
#done
