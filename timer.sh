#!/bin/bash
#crontab -l|grep exec
#if [ $? -ne 0 ];then
crontab ./timer.conf
#fi
