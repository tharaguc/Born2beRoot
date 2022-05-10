#!/bin/bash

ARCH=`uname -a`
CPU=`grep "physical id" /proc/cpuinfo | wc -l`
VCPU=`grep "processor" /proc/cpuinfo | wc -l`
USED=`free -m | grep "Mem" | awk '{print$3}'`
TOTAL=`free -m | grep "Mem" | awk '{print$2}'`
UPT=`echo "scale=2; (${USED} / ${TOTAL}) * 100" | bc`
DISK=`df -h | awk '$NF=="/"{print$3"/"$2" ("$5")"}'`
IDLE=`top -bn1 | grep "%Cpu" | tr ',' ' ' | awk '{print$8}'`
CPU_USE=`echo "scale=1; 100.0 - ${IDLE}" | bc`
LASTREBOOT=`last reboot | awk 'NR==1{print$5"-"$6"-"$7" "$8}'`

wall\
       	"\
	#Architecture : ${ARCH}
	#CPU physical : ${CPU}
	#vCPU : ${VCPU}
	#Memory Usage : ${USED}/${TOTAL}MB (${UPT}%)
	#Disk Usage : ${DISK}
	#CPU load : ${CPU_USE}%
	#Last boot : ${LASTREBOOT} 
	"
