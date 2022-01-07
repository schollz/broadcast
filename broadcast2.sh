#!/bin/bash
echo "streaming at https://broadcast.norns.online/${1}.mp3"
function cleanup {
	pkill -f radio.mp3
}

trap cleanup EXIT
while :
do	
pkill -f radio.mp3
curl -s http://localhost:8000/radio.mp3 | curl -s -k -H "Transfer-Encoding: chunked" -X POST -T -  "https://broadcast.norns.online/${1}.mp3?stream=true"
sleep 1
done
