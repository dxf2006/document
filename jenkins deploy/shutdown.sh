
#!/bin/bash

SERVICE_NAME=gateway-internet
BASE_PATH=/usr/local/vwzt/gateway-internet

PATH_TO_JAR=$SERVICE_NAME".jar"

for i in `ls -t $BASE_PATH/$SERVICE_NAME*.pid 2>/dev/null`
do
    read pid < $i

    result=$(ps -p "$pid")
    if [ "$?" -eq 0 ]; then
        kill -9 $pid
    else
	   pid=`ps -ef | grep $PATH_TO_JAR | grep -v grep | awk '{print $2}'`
	   if [ -n "$pid" ]
	   then
	      kill -9 $pid
	   fi
    fi
    rm -fr $BASE_PATH/$SERVICE_NAME*.pid
    exit 0;
done

#如果没有文件
pid=`ps -ef | grep $PATH_TO_JAR | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
   kill -9 $pid
fi
rm -fr $BASE_PATH/$SERVICE_NAME*.pid
exit 0;
