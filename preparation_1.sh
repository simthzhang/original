#!/bin/bash
ping -n 10 123.58.173.185
ping -n 10 108.61.16.227  
ping -n 10 213.184.126.230

mv rm -rf /etc/yum.repos.d/*.repo
cp ./CentOS6-Base-163_ip.repo /etc/yum.repos.d
yum makecache
yum -y install gcc
yum -y install vim
tar -zxvf nginx-1.7.8.tar.gz
cd nginx-1.7.8
./configure --without-http_rewrite_module --without-http_gzip_module
make && make install
sed -i sed -i '36 s/listen       80;/listen       8080;/g' /usr/local/nginx/config/nginx.conf
rm -rf /usr/local/nginx/html/*
cd /usr/local/nginx/html/
dd if=/dev/zero of=1K bs=1K count=1
dd if=/dev/zero of=10K bs=10K count=1
dd if=/dev/zero of=100K bs=100K count=1
dd if=/dev/zero of=1M bs=1M count=1
dd if=/dev/zero of=10M bs=10M count=1
dd if=/dev/zero of=100M bs=100M count=1
dd if=/dev/zero of=1G bs=1G count=1
dd if=/dev/zero of=10G bs=1G count=10
/usr/local/nginx/sbin/nginx



