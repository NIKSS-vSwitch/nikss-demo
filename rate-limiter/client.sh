#!/bin/bash

. ./config.env

iperf -c $SERVER1_IP -b 100M -u -i 1
