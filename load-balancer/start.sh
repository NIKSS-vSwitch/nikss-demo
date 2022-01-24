#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Configuring load-balancer rules..."

set -xe

# ----------------------- Routing table -------------------------------------------------
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$SERVER_VIRTUAL_IP/32" data group 1
psabpf-ctl table update pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$CLIENT_IP/$CLIENT_IP_PREFIX" data 6

echo "Load-balancer configured successfully!"
