#!/usr/bin/env bash

swapsize=2048
swapfile=swap0

# does the swap file already exist?
grep -q "$swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	echo 'swapfile not found. Adding swapfile.'
	fallocate -l "$swapsize"M /$swapfile
	chmod 600 /$swapfile
	mkswap /$swapfile
	swapon /$swapfile
	echo "/${swapfile} none swap defaults 0 0" >> /etc/fstab
else
	echo "${swapfile} found. No changes made."
fi

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap

# swappiness

echo "set swappines to 11 at runtime"
sleep 1
sysctl -w vm.swappiness=11
echo "set to permanent ine sysctl.conf"
echo 'vm.swappiness=11' >> /etc/sysctl.d/99-swappiness.conf
