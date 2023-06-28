#!/bin/bash

if [ ! -d "./dist_"$1"" ] 
then
    sudo mkdir dist_"$1"
    echo "========= DIRECTORIO CREADO ========="
fi

counter=$3
brlast=$4
braux=$7
procentaje=$5

while [ $counter -lt $6 ]
do
    echo "========= EXPERIMENTO "$counter" a "$1" ========="

    sudo tcpdump -U -i wlan1 -vvv -w ./dist_"$1"/"$1"_"$counter".pcap &> result.txt &
    sleep 1s

    sudo iperf3 -c $2 -u -t 10 -J -b "$counter"K > ./dist_"$1"/"$1"_"$counter".json
    br=$(cat ./dist_"$1"/"$1"_"$counter".json | jq -r '.end.sum.bytes')
    echo "bytes: "$br""
    echo "byteslast: "$brlast""
    sleep 1s

    pid=$(ps -e | pgrep tcpdump)
    #echo "========= PID: "$pid" ========="
    sleep 2s
    kill -2 $pid

    error_count=$(cat ./dist_"$1"/"$1"_"$counter".json | grep error | wc -l)
    if (( $brlast > $br ))
    then
        error_count=1
        brlast=$(echo "scale=0; $braux * $5" | bc -l | xargs printf "%.0f")
    fi
    if [ $error_count -eq 0 ]
    then
        #echo "========= EXP "$counter" TERMINADO ========="
        counter=`expr $counter + 100`
        brlast=$br
        braux=$br
    else
        echo "========= EXP "$counter" CON ERRORES SE REPITE ========="
    fi
    sleep 1s
    sudo rm ./result.txt
done

echo "========= EXPERIMENTOS COMPLETADOS ========="

exit
