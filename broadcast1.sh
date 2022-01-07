#!/bin/bash


if (( $(ps -ef | grep -v grep | grep icecast2 | wc -l) > 0 ))
then
 echo "icecast running" > /dev/null
else
 echo "starting icecast"
 pkill -f broadcast2
 nohup icecast2 -c /home/we/dust/code/radio-broadcast/icecast.xml &
 sleep 1
fi

if (( $(ps -ef | grep -v grep | grep darkice | wc -l) > 0 ))
then
 echo "darkice running" > /dev/null
else
 pkill -f broadcast2 # kills broadcast
 pkill -f radio.mp3 # kills curl
 nohup darkice -c /home/we/dust/code/radio-broadcast/darkice.cfg &
 sleep 1
 jack_connect crone:output_1 darkice:left
 jack_connect crone:output_2 darkice:right
 sleep 1
fi

if (( $(ps -ef | grep -v grep | grep radio.mp3 | wc -l) > 0 ))
then
 echo "broadcaster running" > /dev/null
else
 nohup /home/we/dust/code/radio-broadcast/broadcast2.sh `cat /home/we/dust/data/radio-broadcast/station` &
fi
