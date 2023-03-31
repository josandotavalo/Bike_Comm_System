#!/bin/bash

if [ ! -d "./dist_"$1"" ] 
then
    sudo mkdir dist_"$1"
    echo "========= DIRECTORIO CREADO ========="
fi

counter=1
sleep 1s

while [ $counter -lt 11 ]
do
    echo "========= EXPERIMENTO "$counter" a "$1" ========="

    sudo tcpdump -U -i wlan1 -vvv -w ./dist_"$1"/"$1"_"$counter".pcap &
    sleep 1s

    sudo iperf3 -c 10.0.0.11 -u -t 10 -b 200K -J > ./dist_"$1"/"$1"_"$counter".json
    sleep 1s

    pid=$(ps -e | pgrep tcpdump)
    echo "========= PID: "$pid" ========="
    sleep 2s
    kill -2 $pid

    error_count=$(cat ./dist_"$1"/"$1"_"$counter".json | grep error | wc -l)
    if [ $error_count -eq 0 ]
    then
        echo "========= EXP "$counter" TERMINADO ========="
        counter=`expr $counter + 1`
    else
        echo "========= EXP "$counter" CON ERRORES SE REPITE ========="
    fi
    sleep 1s
done

echo "========= EXPERIMENTOS COMPLETADOS ========="

exit