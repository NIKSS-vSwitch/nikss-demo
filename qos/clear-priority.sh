#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Clearing priority for ICMP traffic..."

nikss-ctl table delete pipe "$PIPELINE" DemoIngress_qos_classifier key 0x1
