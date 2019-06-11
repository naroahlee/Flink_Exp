#!/bin/bash
Flink_IP=192.168.1.11
Flink_PORT=8081
JAR_PATH=/home/NFS_Share/Flink_Exp/Jar/KMeans.jar

curl -X POST -H "Expect:" -F "jarfile=@${JAR_PATH}" http://${Flink_IP}:${Flink_PORT}/jars/upload
echo " "
