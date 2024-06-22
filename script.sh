#!/bin/bash

architecture=$(uname -a)

cpu_phy=$(grep "physical id" /proc/cpuinfo | wc -l)

cpu_vir=$(grep "processor" /proc/cpuinfo | wc -l)

ram_available=$(free --mega | awk '$1 == "Mem:" {print $7}')

ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f", ($3/$2)*100)}')

disk_available=$(df -m | grep "^/dev/" | grep -v "/boot" | awk '{disk_a += $4} END {printf("%.2fGb", disk_a/1024)}')

disk_percent=$(df -m | grep "^/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%.2f", disk_u/disk_t*100)}>

cpu=$(vmstat 1 2 | tail -1 | awk '{printf("%.2f", (100 - $15))}')

last_boot=$(who -b | awk '$1 == "arranque" {print $4 " " $5}')

lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

conex=$(ss -ta | grep ESTAB | wc -l)

registered_u=$(grep -vE '/nologin$|/sync$' /etc/passwd | wc -l)

active_u=$(users | wc -w)

ip=$(hostname -I | awk '{print $1}')

MAC=$(ip link | grep "link/ether" | awk '{print $2}')

cmnd_sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -w)

wall "  Architecture: $arch
        CPU physical: $cpu_phy
        vCPU: $cpu_vir
        RAM Available: $ram_available
        RAM Usage: $ram_percent%
        Disk Available: $disk_available
        Disk Usage: $disk_percent%
        CPU load: $cpu%
        Last boot: $last_boot
        LVM use: $lvm
        Connections TCP: $conex ESTABLISHED
        Registered users: $registered_u
        Active_u: $active_u
        Ipv4 (MAC): $ip ($MAC)
        Sudo: $cmnd_sudo cmd"


