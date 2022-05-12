#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Configuring routing rules..."

set -xe

# ----------------------- Forward actions for Action Selector ---------------------------
# member-ref: 1
psabpf-ctl action-selector add_member pipe "$PIPELINE" DemoIngress_as id 1 \
        data "$SWITCH_SERVER1_PORT_ID" "$SWITCH_SERVER1_PORT_MAC" "$SERVER1_MAC"
# member-ref: 2
psabpf-ctl action-selector add_member pipe "$PIPELINE" DemoIngress_as id 1 \
        data "$SWITCH_SERVER2_PORT_ID" "$SWITCH_SERVER2_PORT_MAC" "$SERVER2_MAC"
# member-ref: 3
psabpf-ctl action-selector add_member pipe "$PIPELINE" DemoIngress_as id 1 \
        data "$SWITCH_CLIENT_PORT_ID" "$SWITCH_CLIENT_PORT_MAC" "$CLIENT_MAC"

# ----------------------- Routing table -------------------------------------------------
# For now pure forwarding without load balancing
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$SERVER1_IP/32" data 1
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$SERVER2_IP/32" data 2
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$CLIENT_IP/$CLIENT_IP_PREFIX" data 3

# ----------------------- ARP responses for requests ------------------------------------
# Always respond with port MAC for whole subnet
# ARP reques - opcode 1
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_arp_ipv4 id 2 key "$SWITCH_SERVER1_PORT_ID" 1 "$SERVER1_IP/$SERVER1_IP_PREFIX" \
        data "$SWITCH_SERVER1_PORT_MAC"
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_arp_ipv4 id 2 key "$SWITCH_SERVER2_PORT_ID" 1 "$SERVER2_IP/$SERVER2_IP_PREFIX" \
        data "$SWITCH_SERVER2_PORT_MAC"
psabpf-ctl table add pipe "$PIPELINE" DemoIngress_tbl_arp_ipv4 id 2 key "$SWITCH_CLIENT_PORT_ID" 1 "$CLIENT_IP/$CLIENT_IP_PREFIX" \
        data "$SWITCH_SERVER2_PORT_MAC"

echo "Routing rules inserted successfully!"
