#!/bin/bash
 
date1="2016-05-27 12:58:49"
date2="2016-05-27 12:56:46"
 
t1=`date -d "$date1" +%s`
t2=`date -d "$date2" +%s`
 
echo $t1
echo $t2
 
if [ $t1 -gt $t2 ]; then
    echo "$date1 > $date2"
elif [ $t1 -eq $t2 ]; then
    echo "$date1 == $date2"
else
    echo "$date1 < $date2"
fi

t3=$[ ($t2 - $t1)/60 ]
data3= 
echo 'the time gap is' $t3 'minutes'
