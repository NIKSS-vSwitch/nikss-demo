#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Removing load-balancer rules..."

set -xe

# ----------------------- Routing table -------------------------------------------------
psabpf-ctl table delete pipe "$PIPELINE" DemoIngress_tbl_routing key "$SERVER_VIRTUAL_IP/32"
psabpf-ctl table update pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$CLIENT_IP/$CLIENT_IP_PREFIX" data 3

echo "Removed load-balancer successfully!"
