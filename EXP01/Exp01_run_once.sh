#!/bin/bash

WORKING_DIR=/home/NFS_Share/Flink_Exp/EXP01
REMOTE_DIR=/mnt/NFS_Share/Flink_Exp/EXP01
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp12.conf
sleepinterval=60
Sched=FIFO

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

# =================== Collect Data ===================
#SortedFile=data/all_sort_${Sched}.tracing
#cat ./*.tracing > all.tracing
#./bin/trace_filter all.tracing -r -o all_sort.tracing > /dev/null
#mv all_sort.tracing ${SortedFile}
#
## =================== Collect Response Sample ========
#./bin/stat_pre ${SortedFile}
#cat ./*.csv > all_sample.csv
#mv all_sample.csv data/all_sample_${Sched}.csv
#
## ================== Clean Template File =============
#rm -rf ./*.tracing ./*.asy ./*.eps ./*.csv
