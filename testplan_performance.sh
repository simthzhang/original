TEST_SHELL_PATH="/opt/tomcat/webapps/cloudtest/root/goanyea/Network_cycle5"
RALLY_HOST="10.100.211.100"
SLAVE_REPORT_PATH="/root/performanceTest/Network_cycle5/report"
RALLY_TEST_PATH="/root/performanceTest/Network_cycle5"
RALLY_PROJECT_PATH="/opt/tomcat/webapps/cloudtest/root/goanyea/Network_cycle5"
SLEEP_TIME_BEFORE_START="115200"
CASE_INTERVAL="1800"
All_JSON_TESTCASE_FILE=" create-and-update-volume.json create-from-image-and-delete-volume.json create-from-volume-and-delete-volume.json create-snapshot-and-attach-volume.json modify-volume-metadata.json create-and-attach-volume.json create-and-extend-volume.json create-and-list-snapshots.json create-and-list-volume.json"
TEST_MODE="serial"
#parallel
DEPLOYMENT_UUID="7381d334-1fe9-4fce-b3ed-0f5282b22262"
HOSTS_HOST_IP="15.15.15.12"


#don't need to modify the following codes 
MODIFY_HOSTS_SHELL="modify_hosts.sh" 
HOSTS_HOST_NAME="public.fuel.local" 

ssh $RALLY_HOST "if [ ! -d '$RALLY_TEST_PATH' ]; then 
        mkdir -p '$RALLY_TEST_PATH' 
fi" 

echo "copy all json case file to slave: $RALLY_HOST" 
for file in $All_JSON_TESTCASE_FILE 
do 
         scp $RALLY_PROJECT_PATH/$file $RALLY_HOST:$RALLY_TEST_PATH/$file 
 done 

echo "configure hosts in slave: $RALLY_HOST" 
scp $TEST_SHELL_PATH/$MODIFY_HOSTS_SHELL $RALLY_HOST:$RALLY_TEST_PATH/$MODIFY_HOSTS_SHELL
ssh $RALLY_HOST "chmod 777 $RALLY_TEST_PATH/$MODIFY_HOSTS_SHELL"
ssh $RALLY_HOST "$RALLY_TEST_PATH/$MODIFY_HOSTS_SHELL $HOSTS_HOST_NAME $HOSTS_HOST_IP"

echo "start to execute performance test in slave: $RALLY_HOST"
scp $TEST_SHELL_PATH/cloud_performance.sh $RALLY_HOST:$RALLY_TEST_PATH/cloud_performance.sh
ssh $RALLY_HOST "chmod 777 $RALLY_TEST_PATH/cloud_performance.sh"
ssh $RALLY_HOST "$RALLY_TEST_PATH/cloud_performance.sh $RALLY_TEST_PATH $SLAVE_REPORT_PATH $SLEEP_TIME_BEFORE_START $CASE_INTERVAL $TEST_MODE $DEPLOYMENT_UUID $All_JSON_TESTCASE_FILE"

echo "get test result back from: $RALLY_HOST"
scp -r $RALLY_HOST:$SLAVE_REPORT_PATH $RALLY_PROJECT_PATH
echo "performance test finished on slave: $RALLY_HOST"

