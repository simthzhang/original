#!/bin/bash

RALLY_TEST_PATH=$1
REPORT_PATH=$2
SLEEP_TIME_BEFORE_START=$3
CASE_INTERVAL=$4
TEST_MODE=$5
DEPLOYMENT_UUID=$6

if [ ! -d "$REPORT_PATH" ]; then 
	mkdir -p "$REPORT_PATH" 
fi

shift 6

sleep $SLEEP_TIME_BEFORE_START

if [ $TEST_MODE = 'serial' ];then
	echo "serial mode selected"
	until [ $# -eq 0 ]
	do
		tmp_jsonfile_fullname=$1
		tmp_log_filename=`echo ${tmp_jsonfile_fullname%%.*}`".log"
		tmp_report_filename=`echo ${tmp_jsonfile_fullname%%.*}`".html"
		rally --log-file $REPORT_PATH/$tmp_log_filename task start --deployment $DEPLOYMENT_UUID $RALLY_TEST_PATH/$tmp_jsonfile_fullname &>/dev/null
		TASK_ID=`grep -o -P "\w{8}-\w{4}-\w{4}-\w{4}-\w{12}" $REPORT_PATH/$tmp_log_filename|awk "END {print}"` 
		rally task report $TASK_ID --html --out $REPORT_PATH/$tmp_report_filename
		sleep $CASE_INTERVAL
		shift 1
	done
elif [ $TEST_MODE = 'parallel' ];then
	echo "parallel mode selected"
	counter=0
	for test_json_file in $@
	do
		tmp_log_filename=`echo ${test_json_file%%.*}`".log"
		counter=`expr $counter + 1`
		if [ $counter -eq $# ];then
			rally --log-file $REPORT_PATH/$tmp_log_filename task start --deployment $DEPLOYMENT_UUID $RALLY_TEST_PATH/$test_json_file &
		else
			rally --log-file $REPORT_PATH/$tmp_log_filename task start --deployment $DEPLOYMENT_UUID $RALLY_TEST_PATH/$test_json_file &
		fi
	done
	echo "wait for all tests finished"
	wait
	ALL_LOG_FILES=`ls $REPORT_PATH/*.log`
	for logfilepath in $ALL_LOG_FILES
	do
		tmp_report_filepath=`echo ${logfilepath%%.*}`".html"
		TASK_ID=`grep -o -P "\w{8}-\w{4}-\w{4}-\w{4}-\w{12}" $logfilepath|awk "END {print}"`
		echo "Generate report of task: $TASK_ID"
		rally task report $TASK_ID --html --out $tmp_report_filepath
	done
else
	echo "Test mode error"
fi



