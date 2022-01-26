#!/bin/bash

. ./config.env

iperf -c $SERVER1_IP -b 10M -u