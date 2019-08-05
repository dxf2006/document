

#!/bin/bash

SERVICE_NAME=gateway-internet
BASE_PATH=/usr/local/vwzt/gateway-internet
SERVER_PORT=5005
SERVER_URL="http://localhost:$SERVER_PORT"
START_PARAM=-Dapollo.cluster=cluster-internet

#
LOG_FILE=logs/$SERVICE_NAME/console.log
mkdir -p logs/$SERVICE_NAME

PATH_TO_JAR=$BASE_PATH/$SERVICE_NAME".jar"
JAVA_OPTS=" -server -Xms1024m -Xmx1024m -Xss256k -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=384m" 

function checkPidAlive {
    for i in `ls -t $BASE_PATH/$SERVICE_NAME*.pid 2>/dev/null`
    do
        read pid < $i

        result=$(ps -p "$pid")
        if [ "$?" -eq 0 ]; then
            return 0
        else
            printf "\npid - $pid just quit unexpectedly, please check logs under $LOG_DIR and /tmp for more information!\n"
            exit 1;
        fi
    done

    printf "\nNo pid file found, startup may failed. Please check logs under $LOG_DIR and /tmp for more information!\n"
    exit 1;
}


printf "$(date) ==== Starting ==== \n"

nohup java $JAVA_OPTS $START_PARAM -jar $PATH_TO_JAR $>>$LOG_FILE 2>&1 &

echo $! > $BASE_PATH/$SERVICE_NAME".pid"

rc=$?;

if [[ $rc != 0 ]];
then
    echo "$(date) Failed to start $SERVICE_NAME.jar, return code: $rc"
    exit $rc;
fi

declare -i counter=0
declare -i max_counter=48 # 48*5=240s
declare -i total_time=0

printf "Waiting for server startup "
until [[ (( counter -ge max_counter )) || "$(curl -X GET --silent --connect-timeout 1 --max-time 2 --head $SERVER_URL | grep "HTTP")" != "" ]];
do
    printf "."
    counter+=1
    sleep 5

    checkPidAlive
done


total_time=counter*5

if [[ (( counter -ge max_counter )) ]];
then
    printf "\n$(date) Server failed to start in $total_time seconds!\n"
    exit 1;
fi

printf "\n$(date) Server started in $total_time seconds!\n"

exit 0;

