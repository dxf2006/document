#!/bin/bash

SERVICE_NAME=vwzt-admin
RELEASE_JAR=vwzt-admin-core-1.0.0-SNAPSHOT.jar

BASE_PATH=/usr/local/vwzt/vwzt-admin
BACK_PATH=/usr/local/vwzt_back/vwzt-admin
RELEASE_PATH=/usr/local/vwzt_relase/vwzt-admin

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

#启动服务
printf "starting  start service \n"
cp $RELEASE_PATH/$RELEASE_JAR $BASE_PATH/$PATH_TO_JAR

sh $BASE_PATH/start.sh

#删除多余的备份
sh del_vwzt_backup.sh $BACK_PATH

