#!/bin/sh

# size of swapfile in megabytes
swapsize=1024

# does the swap file already exist ?
grep -q "swap0" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	echo 'swap0 not found. Adding swap0.'
	fallocate -l ${swapsize}M /swap0
	chmod 600 /swap0
	mkswap /swap0
	swapon /swap0
	echo '/swap0 none swap defaults 0 0' >> /etc/fstab
else
	echo 'swap0 found. No changes made.'
fi

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap
