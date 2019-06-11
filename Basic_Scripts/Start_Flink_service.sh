#!/bin/bash

Flink_IP=192.168.1.11
Flink_PORT=8081
Flink_REMOTEDIR=/home/lihaoran/Flink/flink-1.8.0

# =============== Start Modified YSB  ======================
echo "[Environment] Start Flink Standalone Server @ ${Flink_IP}"
echo "[Environment] Please wait for Flink Initialization..."
ssh lihaoran@${Flink_IP} "${Flink_REMOTEDIR}/bin/start-cluster.sh"
sleep 5
echo "[Environment] Ready to work."

