#!/bin/bash

# Funciton to get public ip and assign it to variable "ip".
getIP () {
        ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
}

# Ensuring we don't get an empty IP as output.
getIP
until [[ -n "$ip"  ]]; do
        getIP
done
echo "$ip"

