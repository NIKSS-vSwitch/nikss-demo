#!/bin/bash

. ./scripts/runtime_cfg.sh

echo "Configuring load-balancer rules..."

set -xe

# ----------------------- Load balancing actions for Action Selector --------------------
# Add them here, so they always will have the same references because this script should run once.
# member-ref: 4
nikss-ctl action-selector add-member pipe "$PIPELINE" DemoIngress_as action id 2 \
        data "$SWITCH_SERVER1_PORT_ID" "$SWITCH_SERVER1_PORT_MAC" "$SERVER1_MAC" "$SERVER1_IP"
# member-ref: 5
nikss-ctl action-selector add-member pipe "$PIPELINE" DemoIngress_as action id 2 \
        data "$SWITCH_SERVER2_PORT_ID" "$SWITCH_SERVER2_PORT_MAC" "$SERVER2_MAC" "$SERVER2_IP"
# group-ref: 1
nikss-ctl action-selector create-group pipe "$PIPELINE" DemoIngress_as
nikss-ctl action-selector add-to-group pipe "$PIPELINE" DemoIngress_as 4 to 1
nikss-ctl action-selector add-to-group pipe "$PIPELINE" DemoIngress_as 5 to 1

# ----------------------- Virtual IP actions for Action Selector ------------------------
# See comment for earlier section
# member-ref: 6
nikss-ctl action-selector add-member pipe "$PIPELINE" DemoIngress_as action id 3 \
        data "$SWITCH_CLIENT_PORT_ID" "$SWITCH_CLIENT_PORT_MAC" "$CLIENT_MAC" "$SERVER_VIRTUAL_IP"

# ----------------------- Routing table -------------------------------------------------
nikss-ctl table add pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$SERVER_VIRTUAL_IP/32" data group 1
nikss-ctl table update pipe "$PIPELINE" DemoIngress_tbl_routing ref key "$CLIENT_IP/$CLIENT_IP_PREFIX" data 6

echo "Load-balancer configured successfully!"
