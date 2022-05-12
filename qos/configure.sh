#!/bin/bash

declare -a SWITCH_INTFS=("eth0" "eth1" "eth2")

for intf in "${SWITCH_INTFS[@]}" ; do
  ip netns exec switch tc qdisc replace dev $intf root handle 1: htb default 200
  # 100 mbit is used to simulate congestion on an interface to see impact on the traffic delay
  ip netns exec switch tc class add dev $intf parent 1: classid 1:1 htb rate 100mbit
  # configure 3 classes, each has the same rate configured, but different priorities
  ip netns exec switch tc class add dev $intf parent 1:1 classid 1:10 htb rate 100mbit prio 1
  ip netns exec switch tc class add dev $intf parent 1:1 classid 1:200 htb rate 100mbit prio 3
  # confiugre fq_codel for each class
  ip netns exec switch tc qdisc add dev $intf parent 1:10 fq_codel
  # associate skb->priority with HTB class
  ip netns exec switch tc filter add dev $intf parent 1: basic match 'meta(priority eq 10)' classid 1:10
  # dump QoS configuration of an interface
  # ip netns exec switch tc -s class show dev $intf
done
