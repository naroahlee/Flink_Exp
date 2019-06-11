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

# Submit Jobs 
jarid = jarfile['id']
jobid = submitJobtoFlink(jarid)
print jobid


