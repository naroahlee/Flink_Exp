#!/bin/bash

Flink_IP=192.168.1.11
Flink_PORT=8081
Flink_REMOTEDIR=/home/lihaoran/Flink/flink-1.8.0
JAR_PATH=/home/NFS_Share/Flink_Exp/Jar/KMeans.jar

# =============== Start Modified YSB  ======================
echo "[Environment] Start Flink Standalone Server @ ${Flink_IP}"
echo "[Environment] Please wait for Flink Initialization..."
ssh lihaoran@${Flink_IP} "${Flink_REMOTEDIR}/bin/start-cluster.sh"
sleep 3

# ============== Change Priority and Affinity =============
Session_PID=`ssh lihaoran@${Flink_IP} "ps aux" | grep "StandaloneSessionClusterEntrypoint" | grep -v grep | awk '{print $2}'`
echo "[Environment] Set Session[${Session_PID}] Pin@VCPU0, SCHED_FIFO Prio[95]"
ssh root@${Flink_IP} "taskset -p 0x1 ${Session_PID}; chrt -f -p 95 ${Session_PID}"

TaskExecutor_PID=`ssh lihaoran@${Flink_IP} "ps aux" | grep "TaskManagerRunner" | grep -v grep | awk '{print $2}'`
echo "[Environment] Set Session[${TaskExecutor_PID}] Pin@VCPU1, SCHED_FIFO Prio[95]"
ssh root@${Flink_IP} "taskset -p 0x2 ${TaskExecutor_PID}; chrt -f -p 95 ${TaskExecutor_PID}"

sleep 2
echo "[Environment] Ready to work."

echo "[Environment] Upload Jar File."
curl -X POST -H "Expect:" -F "jarfile=@${JAR_PATH}" http://${Flink_IP}:${Flink_PORT}/jars/upload
echo " "
