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
LAST_REBOOT=`last reboot | awk 'NR==1{print$5"-"$6"-"$7" "$8}'`
LVM_COMP=`lsblk | grep "lvm" | awk '{print$6}' | uniq`

if [ "$LVM_COMP" = "lvm" ]; then
	LVM_USE="yes"
else
	LVM_USE="no"
fi

TCP_CNCT=`ss -s | grep "TCP:" | awk '{print$4}' | tr -d ','`
USER_LOG=`who --count | grep "users" | tr '=' ' ' | awk '{print$3}'`
IP=`hostname -I`
MAC=`ip addr | grep "link/ether" | awk '{print$2}'`
SUDO=`sudo sudoreplay -l | wc -l`

wall\
       	"\
	#Architecture : ${ARCH}
	#CPU physical : ${CPU}
	#vCPU : ${VCPU}
	#Memory Usage : ${USED}/${TOTAL}MB (${UPT}%)
	#Disk Usage : ${DISK}
	#CPU load : ${CPU_USE}%
	#Last boot : ${LAST_REBOOT}
	#LVM use : ${LVM_USE}
	#Connections TCP : ${TCP_CNCT} ESTABLISHED
	#User log : ${USER_LOG}
	#NetWork : IP ${IP} (${MAC})
	#Sudo : ${SUDO} cmd"
