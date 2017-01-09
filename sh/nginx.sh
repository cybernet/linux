#!/bin/sh
SERVICE=nginx
if ps ax | grep -v grep | grep -v $0 | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, everything is fine"
else
    echo "$SERVICE is not running"
fi
