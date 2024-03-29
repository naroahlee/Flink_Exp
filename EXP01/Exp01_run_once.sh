#!/bin/bash

WORKING_DIR=/home/NFS_Share/Flink_Exp/EXP01
REMOTE_DIR=/mnt/NFS_Share/Flink_Exp/EXP01
CLIENT_IP=192.168.1.12
sleepinterval=60

cd ${WORKING_DIR}

# ====================== SERVER ======================
echo "[EXP01]: Start Flink Server"
../Basic_Scripts/Start_Flink_service.sh

sleep 5

echo "[EXP01]: Start Periodic Client"
# ====================== CLIENT ======================
ssh lihaoran@${CLIENT_IP} "cd ${REMOTE_DIR}; ./periodic_evl.py > /dev/null &"

# ====================== RUN Exp =====================
echo "============================"
elapsedtime=0
checkclient=`ssh lihaoran@${CLIENT_IP} ps aux | grep -v grep | grep periodic_evl`
while [ "${#checkclient}" -gt 0 ]
do
	echo "[EXP01] Periodic Client is running. Elapsed Time = [${elapsedtime} min]"
	sleep ${sleepinterval}
	elapsedtime=`echo ${elapsedtime} + 1 | bc`
	checkclient=`ssh lihaoran@${CLIENT_IP} ps aux | grep -v grep | grep periodic_evl`
done
echo "============================"

echo "[EXP01]: Getting Response Time"
./getResponseTime.py

# =================== KILL SERVER ====================
echo "[EXP01]: Stop Flink Server"
../Basic_Scripts/Stop_Flink_service.sh

# ====================================================
# ====================================================
# ==================Post Processing ==================
# ====================================================
# ====================================================

