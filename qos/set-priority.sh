#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Setting priority for ICMP traffic..."

set -xe

nikss-ctl table add pipe "$PIPELINE" DemoIngress_qos_classifier action id 1 key 1
