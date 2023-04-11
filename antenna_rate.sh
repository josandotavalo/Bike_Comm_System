#!/bin/bash

echo "========= DETERMINACION DE BITRATE VALIDOS ========="

for rate in {1..54..1}
do
    counter=1
    while [ $counter -lt 4 ]
    do
        sudo iwconfig wlan1 rate "$rate"M &> output.txt
        error_count=$(cat ./output.txt | grep Error | wc -l)
        if [ $error_count -eq 0 ]
        then
            echo "========= BITRATE "$counter": "$rate"M NO VALIDO ========="
            counter=`expr $counter + 1`
        else
            echo "========= BITRATE "$counter": "$rate"M OK ========="
            counter=4
        fi
        sleep 5s
    done
done