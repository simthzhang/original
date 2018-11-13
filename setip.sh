#!/bin/bash
dhclient eth0
kill -9  `ps -ef|grep dhclient|awk '{print $2}'`

dhclient eth1
sleep 1
kill -9  `ps -ef|grep dhclient|awk '{print $2}'`
dhclient eth2
kill -9  `ps -ef|grep dhclient|awk '{print $2}'`
dhclient eth3
kill -9  `ps -ef|grep dhclient|awk '{print $2}'`
