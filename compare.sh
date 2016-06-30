#!/bin/bash
	cat /tmp/1.log | while read myline
	do
	cat /tmp/2.log|grep `echo $myline|awk '{print $2}'`
		if [ "$?" -eq 0 ]
		then
			echo $myline
		fi
done
