#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Clearing priority for ICMP traffic..."

psabpf-ctl table delete pipe "$PIPELINE" DemoIngress_qos_classifier key 0x1
