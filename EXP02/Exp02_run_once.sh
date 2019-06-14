#!/bin/bash

WORKING_DIR=/home/NFS_Share/Flink_Exp/EXP02
REMOTE_DIR=/mnt/NFS_Share/Flink_Exp/EXP02
CLIENT_IP=192.168.1.12
sleepinterval=60

cd ${WORKING_DIR}

# ====================== SERVER ======================
echo "[EXP02]: Start Flink Server"
../Basic_Scripts/Start_Flink_service.sh

sleep 5

echo "[EXP02]: Start Poisson Client"
# ====================== CLIENT ======================
ssh lihaoran@${CLIENT_IP} "cd ${REMOTE_DIR}; ./poisson_evl.py > /dev/null &"

# ====================== RUN Exp =====================
echo "============================"
elapsedtime=0
checkclient=`ssh lihaoran@${CLIENT_IP} ps aux | grep -v grep | grep poisson_evl`
while [ "${#checkclient}" -gt 0 ]
do
	echo "[EXP02] Poisson Client is running. Elapsed Time = [${elapsedtime} min]"
	sleep ${sleepinterval}
	elapsedtime=`echo ${elapsedtime} + 1 | bc`
	checkclient=`ssh lihaoran@${CLIENT_IP} ps aux | grep -v grep | grep poisson_evl`
done
echo "============================"

echo "[EXP02]: Getting Response Time"
./getResponseTime.py

# =================== KILL SERVER ====================
echo "[EXP02]: Stop Flink Server"
../Basic_Scripts/Stop_Flink_service.sh

# ====================================================
# ====================================================
# ==================Post Processing ==================
# ====================================================
# ====================================================
