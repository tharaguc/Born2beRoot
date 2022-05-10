#!/bin/bash

ARCH=`uname -a`
CPU=`grep "physical id" /proc/cpuinfo | wc -l`
VCPU=`grep "processor" /proc/cpuinfo | wc -l`
USED=`free -m | grep "Mem" | awk '{print$3}'`
TOTAL=`free -m | grep "Mem" | awk '{print$2}'`
UPT=`echo "scale=2; (${USED} / ${TOTAL}) * 100" | bc`
DISK=`df -h | awk '$NF=="/"{print$3"/"$2" ("$5")"}'`

wall\
       	"\
	#Architecture : ${ARCH}
	#CPU physical : ${CPU}
	#vCPU : ${VCPU}
	#Memory Usage : ${USED}/${TOTAL}MB (${UPT}%)
	#Disk Usage : ${DISK} 
	"
