#!/bin/sh

# size of swapfile in megabytes
swapsize=2048

# does the swap file already exist?
grep -q "swap2g" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	echo 'swapfile not found. Adding swapfile.'
	fallocate -l ${swapsize}M /swap2g
	chmod 600 /swap2g
	mkswap /swap2g
	swapon /swap2g
	echo '/swap2g none swap defaults 0 0' >> /etc/fstab
else
	echo 'swapfile found. No changes made.'
fi

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap
