#!/bin/bash
apt-get install vconfig
vconfig add eth0 101
ifconfig eth0.101 192.168.20.100/24 up
ifconfig eth1 172.16.0.3/24 up
ifconfig eth1 172.16.0.100/24 up
ping 172.16.0.3
cd /home/tempest/tempest/tempest/api/identity/v2/
nosetests test_tokens.py
date -s "06/09/16 06:30:34"
nosetests test_tokens.py
