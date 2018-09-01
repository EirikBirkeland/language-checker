#!/bin/bash
file_old=$(stat -c%y $1 | cut -d ' ' -f 2)
printf $file_old
while :
do
   file_new=$(stat -c%y $1 | cut -d ' ' -f 2)
   if [ ! $file_new == $file_old ]; then
       printf $file_new
       file_old=$file_new
       perl $1
   fi
   sleep 2 
done
