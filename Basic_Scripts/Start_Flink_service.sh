#!/bin/bash

FlinkMaster_IP=192.168.1.10
FlinkWorker_IP=192.168.1.11
Flink_PORT=8081
Flink_REMOTEDIR=/home/lihaoran/Flink/flink-1.8.0
JAR_PATH=/home/NFS_Share/Flink_Exp/Jar/KMeans.jar

# =============== Start Modified YSB  ======================
echo "[Environment] Start Flink Standalone Server @ ${FlinkMaster_IP}"
echo "[Environment] Please wait for Flink Initialization..."
ssh lihaoran@${FlinkMaster_IP} "${Flink_REMOTEDIR}/bin/start-cluster.sh"
sleep 3

# ============== Change Priority and Affinity =============
Session_PID=`ssh lihaoran@${FlinkMaster_IP} "ps aux" | grep "StandaloneSessionClusterEntrypoint" | grep -v grep | awk '{print $2}'`
echo "[Environment] Set JobManagerDeamon[${Session_PID}]@${FlinkMaster_IP}, SCHED_FIFO Prio[95]"
ssh root@${FlinkMaster_IP} "chrt -f -p 95 ${Session_PID}"
#echo "[Environment] Set Session[${Session_PID}] Pin@VCPU0, SCHED_FIFO Prio[95]"
#ssh root@${FlinkMaster_IP} "taskset -p 0x1 ${Session_PID}; chrt -f -p 95 ${Session_PID}"

TaskExecutor_PID=`ssh lihaoran@${FlinkWorker_IP} "ps aux" | grep "TaskManagerRunner" | grep -v grep | awk '{print $2}'`
echo "[Environment] Set TaskManagerDeamon[${TaskExecutor_PID}]@${FlinkWorker_IP}, SCHED_FIFO Prio[95]"
ssh root@${FlinkWorker_IP} "chrt -f -p 95 ${TaskExecutor_PID}"
#echo "[Environment] Set Session[${TaskExecutor_PID}] Pin@VCPU1, SCHED_FIFO Prio[95]"
#ssh root@${FlinkWork_IP} "taskset -p 0x2 ${TaskExecutor_PID}; chrt -f -p 95 ${TaskExecutor_PID}"

sleep 2
echo "[Environment] Ready to work."

echo "[Environment] Upload Jar File."
curl -X POST -H "Expect:" -F "jarfile=@${JAR_PATH}" http://${FlinkMaster_IP}:${Flink_PORT}/jars/upload
echo " "
