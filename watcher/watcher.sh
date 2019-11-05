#!/bin/sh
echo "watcher service"
touch /arc-data/.env && chmod 777 /arc-data/.env

sleep 5s
### Set initial time of file
LTIME=`stat -c %Z /arc-data/.env`

while true    
do
   ATIME=`stat -c %Z /arc-data/.env`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       docker restart arc
       LTIME=$ATIME
   fi
   sleep 5
done
