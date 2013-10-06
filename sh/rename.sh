#!/bin/bash
# rename all files matching .jpg to prefix_*1-99*.jpg
cd /home/user/working_dir
cnt=0
for fname in *.jpg
do
    mv $fname prefix_${cnt}.jpg
    cnt=$(( $cnt + 1 ))
done
