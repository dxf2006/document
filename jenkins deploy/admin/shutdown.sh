#!/bin/bash

SERVICE_NAME=vwzt-admin
BASE_PATH=/usr/local/vwzt/vwzt-admin

PATH_TO_JAR=$SERVICE_NAME".jar"

for i in `ls -t $BASE_PATH/$SERVICE_NAME*.pid 2>/dev/null`
do
    read pid < $i

    result=$(ps -p "$pid")
    if [ "$?" -eq 0 ]; then
        kill -15 $pid
    else
        pid=`ps -ef | grep $PATH_TO_JAR | grep -v grep | awk '{print $2}'`
        if [ -n "$pid" ]
        then
           kill -15 $pid
        fi
    fi
    rm -fr $BASE_PATH/$SERVICE_NAME*.pid
 #   exit 0;
done

#等待直到退出
declare -i counter=0
declare -i max_counter=48 # 48*5=240s
declare -i total_time=0

printf "Waiting for server stop "
until [[ (( counter -ge max_counter )) ]];
do
    printf "."
    counter+=1

    pid=`ps -ef | grep $PATH_TO_JAR | grep -v grep | awk '{print $2}'`
    if [ -n "$pid" ]
    then
       sleep 5
    else
       total_time=counter*5
       printf "\n$(date) Server normal stoped in $total_time seconds!\n"
       exit 0;
    fi
done

#如果没有文件
pid=`ps -ef | grep $PATH_TO_JAR | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
   kill -9 $pid
fi
rm -fr $BASE_PATH/$SERVICE_NAME*.pid

total_time=counter*5
printf "\n$(date) Server force stoped in $total_time seconds!\n"
exit 0;
