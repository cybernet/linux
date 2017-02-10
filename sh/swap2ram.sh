#!/bin/sh
# http://tipsonubuntu.com/2014/05/27/optimize-swap-ubuntu-1404/
mem=$(free  | awk '/Mem:/ {print $4}')
swap=$(free | awk '/Swap:/ {print $3}')

if [ $mem -lt $swap ]; then
    echo "ERROR: not enough RAM to write swap back, nothing done" >&2
    exit 1
fi

swapoff -a && swapon -a
