#/bin/bash

. ./config.env

set -xe

echo "Creating netns for switch"
sudo ip netns add switch
echo "Creating netns for client"
sudo ip netns add client
echo "Creating netns for server1"
sudo ip netns add server1
echo "Creating netns for server2"
sudo ip netns add server2

echo "Configuring interfaces"

sudo ip -n switch link add name psa_recirc type dummy
sudo ip -n client link add eth0 type veth peer name "$SWITCH_CLIENT_IFACE" netns switch
sudo ip -n server1 link add eth0 type veth peer name "$SWITCH_SERVER1_IFACE" netns switch
sudo ip -n server2 link add eth0 type veth peer name "$SWITCH_SERVER2_IFACE" netns switch

sudo ip netns exec client ip link set lo up
sudo ip netns exec server1 ip link set lo up
sudo ip netns exec server2 ip link set lo up
sudo ip netns exec switch ip link set lo up

sudo ip netns exec client ip addr add "$CLIENT_IP/$CLIENT_IP_PREFIX" dev eth0
sudo ip netns exec server1 ip addr add "$SERVER1_IP/$SERVER1_IP_PREFIX" dev eth0
sudo ip netns exec server2 ip addr add "$SERVER2_IP/$SERVER2_IP_PREFIX" dev eth0

sudo ip netns exec client ip link set eth0 up
sudo ip netns exec server1 ip link set eth0 up
sudo ip netns exec server2 ip link set eth0 up

sudo ip netns exec client ip route add default via "$CLIENT_GATEWAY" dev eth0
sudo ip netns exec server1 ip route add default via "$SERVER1_GATEWAY" dev eth0
sudo ip netns exec server2 ip route add default via "$SERVER2_GATEWAY" dev eth0

sudo ip netns exec switch ip link set "$SWITCH_CLIENT_IFACE" up
sudo ip netns exec switch ip link set "$SWITCH_SERVER1_IFACE" up
sudo ip netns exec switch ip link set "$SWITCH_SERVER2_IFACE" up
sudo ip netns exec switch ip link set psa_recirc up
