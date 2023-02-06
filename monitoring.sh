#!/bin/bash

architecture=`uname -a`
cpu_physical=`lscpu | awk '$1 == "CPU(s):" {printf $2}'`
vcpu=`grep -c "processor" /proc/cpuinfo`
memory_usage=`free -m | awk '$1 == "Mem:" {printf "%s/%sMB (%.2f%%)\n", $3, $2, $3*100/$2}'`
disk_usage=`df -h --total | awk '$1 == "total" {printf("%d/%dGb (%.f%%)\n", $3 * 1000, $2, $5)}'`
cpu_load=`top -bn1 | awk '$1 == "%Cpu(s):" {printf("%.2f%%\n", $2 + $4)}'`
last_boot=`who -b | awk '{print $3, $4}'`
lvm_use=`(lsblk | grep -q "lvm" && echo yes) || echo no`
connections_tcp=`ss -t | grep -c "ESTAB"`
user_log=`users | tr ' ' '\n' | uniq | wc -l`
network=`hostname -I | tr '\n' ' ' && ip a | awk '$1 == "link/ether" {printf("(%s)\n", $2)}'`
sudo=`grep -c "COMMAND" /var/log/sudo/sudo.log | awk '{printf("%d cmd\n", $1)}'`

wall "
#Architecture: $architecture
#CPU physical: $cpu_physical
#vCPU: $vcpu
#Memory usage: $memory_usage
#Disk usage: $disk_usage
#CPU load: $cpu_load
#Last boot: $last_boot
#LVM use: $lvm_use
#Connections TCP: $connections_tcp ESTABLISHED
#User log: $user_log
#Network: $network
#Sudo: $sudo
"
