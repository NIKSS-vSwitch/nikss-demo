#/bin/bash

set -xe

ip netns del client
ip netns del server1
ip netns del server2
ip netns del switch
