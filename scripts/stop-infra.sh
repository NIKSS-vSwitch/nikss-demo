#/bin/bash

set -xe

sudo ip netns del client
sudo ip netns del server1
sudo ip netns del server2
sudo ip netns del switch
