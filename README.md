This is the experimental utilities for Flink experiment of M/G(DS)/1 project, which is the extension of M/D(DS)/1 projext.

We used "KMeans.jar" as workload for Flink Service.
We used python to access REST API to control the job submission.
We used python to retrive the completion job stats via REST API.

Separating Taskexecutor and StandaloneSession to two different VCPUs (with SCHED_FIFO + Prio 95).
Since Flink cannot provide CPU isolation, I had to separate FlinkMaster and FlinkWorker to different VMs:

FlinkMaster   ----- Flink01
192.168.1.10        192.168.1.11



TBD:
1. Poisson Stimulation


