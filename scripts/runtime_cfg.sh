#!/bin/bash

. ./config.env

function get_iface_index() {
    NS=$1
    INERFACE=$2
    ip netns exec "$NS" cat "/sys/class/net/$INERFACE/ifindex"
}

function get_iface_mac() {
    NS=$1
    INERFACE=$2
    ip netns exec "$NS" cat "/sys/class/net/$INERFACE/address" 
}

SWITCH_CLIENT_PORT_ID=$(get_iface_index switch "$SWITCH_CLIENT_IFACE")
SWITCH_CLIENT_PORT_MAC=$(get_iface_mac switch "$SWITCH_CLIENT_IFACE")

SWITCH_SERVER1_PORT_ID=$(get_iface_index switch "$SWITCH_SERVER1_IFACE")
SWITCH_SERVER1_PORT_MAC=$(get_iface_mac switch "$SWITCH_SERVER1_IFACE")

SWITCH_SERVER2_PORT_ID=$(get_iface_index switch "$SWITCH_SERVER2_IFACE")
SWITCH_SERVER2_PORT_MAC=$(get_iface_mac switch "$SWITCH_SERVER2_IFACE")

CLIENT_MAC=$(get_iface_mac client eth0)
SERVER1_MAC=$(get_iface_mac server1 eth0)
SERVER2_MAC=$(get_iface_mac server2 eth0)
