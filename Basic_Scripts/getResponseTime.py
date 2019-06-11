#!/usr/bin/python
# For M/G(DS)/1 system
# Submit KMeans Job to Flink via REST API

import sys
import json
import urllib
import urllib2
import datetime

# ================= Constants =================

FLINKVM_IP     = '192.168.1.11'
FLINK_RESTPORT = '8081'
JAR_FILENAME   = 'KMeans.jar'

def getFinishedJobIDList():
	submit_joburl = 'http://' + FLINKVM_IP + ':' + FLINK_RESTPORT + '/jobs/'
	payload   = json.load(urllib2.urlopen(submit_joburl))['jobs']

	finished_joblist = []
	for item in payload:
		if('FINISHED' == item['status']):
			finished_joblist.append(item['id'])
	return finished_joblist

def getResponseTimeFromID(jobid):
	submit_joburl = 'http://' + FLINKVM_IP + ':' + FLINK_RESTPORT + '/jobs/' + jobid
	duration      = json.load(urllib2.urlopen(submit_joburl))['duration']
	
	return duration

#==================== Main =====================

jobidlist = getFinishedJobIDList()
print("Job Num = [%d]\n" % (len(jobidlist)))

for jobid in jobidlist:
	print getResponseTimeFromID(jobid)

