#!/bin/bash
dhclient eth1
kill -9 `ps -ef|grep dhclient |grep eth |awk '{print $2}'`
dhclient eth2
kill -9 `ps -ef|grep dhclient |grep eth |awk  '{print $2}'`
dhclient eth3
kill -9 `ps -ef|grep dhclient |grep eth |awk '{print $2}'`
