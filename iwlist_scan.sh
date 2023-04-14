#!/bin/bash

CARD='wlp2s0'
COMMAND=$(sudo iwlist ${CARD} scan)
IFS=$'\n'

declare -A regexes
regexes=(\
         ["Address"]="Address:\ *(.*)" \
         ["Channel"]="Channel:\ *(.*)" \
         ["Signal_level"]="Signal\ level=(.*)" \
         ["Essid"]="ESSID:\"(.*)\"" \
        )

data="{}"

for line in $COMMAND; do
  if [[ $line =~ ${regexes["Address"]} ]]; then
    address=${BASH_REMATCH[1]}
  else
    for key in "${!regexes[@]}"; do
      [[ $line =~ ${regexes[$key]} ]] && \
      value=${BASH_REMATCH[1]} && \
      data=$(echo $data | jq --arg address "$address" --arg key "$key" --arg value "$value" '.[$address][$key] |= .+ $value')
    done
  fi
done

echo "$data" > scan"$1".json