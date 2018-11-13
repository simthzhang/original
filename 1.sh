#!/bin/bash
#original date/started date
datetoimput="$1"
#seconds that used
seconds=$2
date_seconds=`date -d "$datetoimput" +%s`
new_date_seconds=`echo $date_seconds |awk '{print int($0) + "'"$seconds"'"}'`
date_new=`date -d @$new_date_seconds "+%Y-%m-%d %H:%M:%S"`
echo $date_new
