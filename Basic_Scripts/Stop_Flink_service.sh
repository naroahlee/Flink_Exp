#!/bin/bash

FlinkMaster_IP=192.168.1.10
Flink_PORT=8081
Flink_REMOTEDIR=/home/lihaoran/Flink/flink-1.8.0

# =============== Start Modified YSB  ======================
echo "[Environment] Stop Flink Standalone Server"
ssh lihaoran@${FlinkMaster_IP} "${Flink_REMOTEDIR}/bin/stop-cluster.sh"
sleep 3
echo "[Environment] Flink Server Stopped."

