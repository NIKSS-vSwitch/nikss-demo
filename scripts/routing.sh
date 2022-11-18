#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Configuring routing rules..."

set -xe

# ----------------------- Forward actions for Action Selector ---------------------------
# member-ref: 1
nikss-ctl action-selector add-member pipe "$PIPELINE" DemoIngress_as action name DemoIngress_forward \
        data "$SWITCH_SERVER1_PORT_ID" "$SWITCH_SERVER1_PORT_MAC" "$SERVER1_MAC"
# member-ref: 2
nikss-ctl action-selector add-member pipe "$PIPELINE" DemoIngress_as action name DemoIngress_forward \
        data "$SWITCH_SERVER2_PORT_ID" "$SWITCH_SERVER2_PORT_MAC" "$SERVER2_MAC"
# member-ref: 3
nikss-ctl action-selector add-member pipe "$PIPELINE" DemoIngress_as action name DemoIngress_forward \
        data "$SWITCH_CLIENT_PORT_ID" "$SWITCH_CLIENT_PORT_MAC" "$CLIENT_MAC"

# ----------------------- Routing table -------------------------------------------------
# For now pure forwarding without load balancing
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$SERVER1_IP/32" data 1
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$SERVER2_IP/32" data 2
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$CLIENT_IP/$CLIENT_IP_PREFIX" data 3

# ----------------------- ARP responses for requests ------------------------------------
# Always respond with port MAC for whole subnet
# ARP reques - opcode 1
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_arp_ipv4 action name DemoIngress_send_arp_reply key "$SWITCH_SERVER1_PORT_ID" 1 "$SERVER1_IP/$SERVER1_IP_PREFIX" \
        data "$SWITCH_SERVER1_PORT_MAC"
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_arp_ipv4 action name DemoIngress_send_arp_reply key "$SWITCH_SERVER2_PORT_ID" 1 "$SERVER2_IP/$SERVER2_IP_PREFIX" \
        data "$SWITCH_SERVER2_PORT_MAC"
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_arp_ipv4 action name DemoIngress_send_arp_reply key "$SWITCH_CLIENT_PORT_ID" 1 "$CLIENT_IP/$CLIENT_IP_PREFIX" \
        data "$SWITCH_SERVER2_PORT_MAC"

echo "Routing rules inserted successfully!"
