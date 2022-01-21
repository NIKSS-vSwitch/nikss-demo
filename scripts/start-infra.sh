#/bin/bash

set -xe

echo "Creating netns for switch"
sudo ip netns add switch
echo "Creating netns for client"
sudo ip netns add client
echo "Creating netns for server1"
sudo ip netns add server1
echo "Creating netns for server2"
sudo ip netns add server2

sudo ip -n switch link add name psa_recirc type dummy
sudo ip -n client link add eth0 type veth peer name eth0 netns switch
sudo ip -n server1 link add eth0 type veth peer name eth1 netns switch
sudo ip -n server2 link add eth0 type veth peer name eth2 netns switch

sudo ip netns exec client ip link set lo up
sudo ip netns exec server1 ip link set lo up
sudo ip netns exec server2 ip link set lo up
sudo ip netns exec switch ip link set lo up

sudo ip netns exec client ip addr add 10.0.0.1/24 dev eth0
sudo ip netns exec server1 ip addr add 17.0.0.1/24 dev eth0
sudo ip netns exec server2 ip addr add 17.0.0.2/24 dev eth0

sudo ip netns exec client ip link set eth0 up
sudo ip netns exec server1 ip link set eth0 up
sudo ip netns exec server2 ip link set eth0 up

sudo ip netns exec client ip route add default via 10.0.0.254 dev eth0
sudo ip netns exec server1 ip route add default via 17.0.0.254 dev eth0
sudo ip netns exec server2 ip route add default via 17.0.0.254 dev eth0

sudo ip netns exec switch ip link set eth0 up
sudo ip netns exec switch ip link set eth1 up
sudo ip netns exec switch ip link set eth2 up
sudo ip netns exec switch ip link set psa_recirc up
