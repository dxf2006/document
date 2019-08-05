
#!/bin/bash

SERVICE_NAME=vwzt-gateway-internet
RELEASE_JAR=vwzt-gateway-1.0.0-SNAPSHOT.jar

BASE_PATH=/usr/local/vwzt/gateway-internet
BACK_PATH=/usr/local/vwzt_back/gateway-internet
RELEASE_PATH=/usr/local/vwzt_relase/gateway-internet

mkdir -p $BACK_PATH
mkdir -p $RELEASE_PATH

PATH_TO_JAR=$SERVICE_NAME".jar"

#暂停服务
printf "starting shutdown... \n"
sh $BASE_PATH/shutdown.sh

#备份文件
printf "starting backup... \n"
backupFile="$BACK_PATH/$PATH_TO_JAR.`date +%Y%m%d%H%M%S`"
mv $BASE_PATH/$PATH_TO_JAR $backupFile 2>/dev/null

#拷贝发布的文件
printf " Starting cp deploy jar ... \n"
cp $RELEASE_PATH/$RELEASE_JAR $BASE_PATH/$PATH_TO_JAR

#启动服务
printf "starting  start service \n"
sh $BASE_PATH/start.sh



