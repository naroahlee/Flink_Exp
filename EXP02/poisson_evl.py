#!/usr/bin/python

import sys
import csv
import time
import json
import urllib
import urllib2

g_offset = 8000
gcounts  = 4000

FLINKVM_IP     = '192.168.1.10'
FLINK_RESTPORT = '8081'
JAR_FILENAME   = 'KMeans.jar'
ARRIVAL_FILE   = 'MGDS1_flink_arrival.csv'

def read_arrival_data(infile):
	arrival_evt = []
	with open(infile, 'rb') as csvfile:
		myreader = csv.reader(csvfile, delimiter=',', quotechar='|')
		for row in myreader:
			for item in row:
				arrival_evt.append(float(item));
	return arrival_evt

def getUploadJarList():
	upload_joburl = 'http://' + FLINKVM_IP + ':' + FLINK_RESTPORT + '/jars' 
	alljarslist   = json.load(urllib2.urlopen(upload_joburl))
	return alljarslist
	
def submitJobtoFlink(jarid):
	# This is an ugly implementation
	# But I don't know how to POST to this REST API with payload via urllib2
	submit_joburl = 'http://' + FLINKVM_IP + ':' + FLINK_RESTPORT + '/jars/' + jarid + '/run?program-args=--iterations+4'
	# A dummy payload, which transfer the Request to a *POST* request
	params   = {}
	urldata  = urllib.urlencode(params)
	request  = urllib2.Request(submit_joburl, urldata)
	response = urllib2.urlopen(request)
	payload  = response.read()
	jobid    = json.loads(payload)['jobid']
	return jobid

#==================== Main =====================

alljarslist = getUploadJarList()
fileslist = alljarslist['files']

# Sanity Check: I only allow exact one Jar file to be uploaded
if(1 != len(fileslist)):
	print "Filelist Error!"
	sys.exit(-1)
jarfile = fileslist[0]
if(JAR_FILENAME != jarfile['name']):
	print "File Name: [%s]: Error!" % (jarfile['name'])
	sys.exit(-1)

jarid = jarfile['id']

arrival_evt = read_arrival_data(ARRIVAL_FILE)
arrival_interval = []
arrival_interval.append(arrival_evt[0])
for i in range(1, len(arrival_evt)):
	arrival_interval.append(arrival_evt[i] - arrival_evt[i-1])

# =============== Start Experiment =============

jobid = submitJobtoFlink(jarid)
time.sleep(10)

# Submit Jobs 
for i in range(g_offset, g_offset + gcounts):
	time.sleep(arrival_interval[i])
	jobid = submitJobtoFlink(jarid)

print "Finished!"


