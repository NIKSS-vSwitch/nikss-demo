#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Configuring rate-limiter rules..."

set -xe

# 1Mb/s -> 128 000 bytes/s (132 kbytes/s PIR, 128 kbytes/s CIR), let cbs, pbs -> 10 ms
psabpf-ctl meter update pipe "$PIPELINE" DemoIngress_meter index "$SWITCH_SERVER1_PORT_ID" 132000:10000 128000:10000

echo "Rate-limiter configured successfully!"
