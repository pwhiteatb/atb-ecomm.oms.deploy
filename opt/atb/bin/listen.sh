#!/bin/bash

lastpid="$(cat /var/lock/listen.pid 2>/dev/null)"
if [ -n "$1" ]; then
        if [ -n "$lastpid" ]; then
                kill $lastpid
        fi
        exit 0;
fi

if [ -n "$(ps -A | grep $lastpid 2>/dev/null)" ]; then
#        echo "Queue listener already running as PID $lastpid"
        exit 1
elif [ -n "$lastpid" ]; then
        echo "Queue listener died unexpectedly!"
fi

echo $$ > /var/lock/listen.pid
rm listen.log storage/logs/*
while [ 1 ]; do
        php artisan schedule:run >listen.log 2>&1
        sleep 60
done
