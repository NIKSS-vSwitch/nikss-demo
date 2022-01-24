#!/bin/bash

. ./config.env

echo "Running 100 requests to server..."

for i in $(seq 1 100); do
    echo "$i: http status: $(curl -s -o /dev/null -w \"%{http_code}\" $SERVER_VIRTUAL_IP:8080)"
    sleep 0.2
done
