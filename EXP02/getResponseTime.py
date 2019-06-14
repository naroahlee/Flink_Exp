#!/usr/bin/python
# For M/G(DS)/1 system
# Submit KMeans Job to Flink via REST API

import sys
import json
import urllib
import urllib2
import datetime

# ================= Constants =================

FLINKVM_IP     = '192.168.1.10'
FLINK_RESTPORT = '8081'
JAR_FILENAME   = 'KMeans.jar'
OUT_FILE       = 'res.csv'

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

def write_data(outfile, arrival_evt):
	with open(outfile, 'w') as outfile:
		for item in arrival_evt:
			outfile.write('%d\n' % int(item))
	return

#==================== Main =====================

jobidlist = getFinishedJobIDList()

response_time = []
for jobid in jobidlist:
	response_time.append( getResponseTimeFromID(jobid))

write_data(OUT_FILE, response_time)
print "Data has been stored in [%s]" % (OUT_FILE)

#print("Job Num = [%d]\n" % (len(jobidlist)))


