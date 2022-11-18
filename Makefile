P4C :=

start:
	@./scripts/start-infra.sh

compile:
	@p4c-ebpf --arch psa --Wdisable=unused -o demo.c demo.p4
	@clang -O2 -g -c -DBTF -emit-llvm -o demo.bc demo.c
	@llc -march=bpf -mcpu=generic -filetype=obj -o demo.o demo.bc

deploy:
	@nsenter --net=/var/run/netns/switch nikss-ctl pipeline load id 1 demo.o
	@echo "Adding ports to switch..."
	@nsenter --net=/var/run/netns/switch nikss-ctl add-port pipe 1 dev psa_recirc
	@nsenter --net=/var/run/netns/switch nikss-ctl add-port pipe 1 dev eth0
	@nsenter --net=/var/run/netns/switch nikss-ctl add-port pipe 1 dev eth1
	@nsenter --net=/var/run/netns/switch nikss-ctl add-port pipe 1 dev eth2
	@echo "Ports successfully added"
	@scripts/routing.sh
	@echo "Done"

clean:
	@nsenter --net=/var/run/netns/switch nikss-ctl pipeline unload id 1 || true
	@./scripts/stop-infra.sh || true
	@rm -f demo.c demo.o demo.bc || true

.PHONY: start compile deploy clean

load-balancer:
	@./load-balancer/start.sh

http-server-1:
	@ip netns exec server1 ./load-balancer/server.py

http-server-2:
	@ip netns exec server2 ./load-balancer/server.py

http-client:
	@ip netns exec client ./load-balancer/client.sh

stop-load-balancer:
	@./load-balancer/stop.sh

rate-limiter:
	@./rate-limiter/start.sh

iperf-server:
	@ip netns exec server1 ./rate-limiter/server.sh

iperf-client:
	@ip netns exec client ./rate-limiter/client.sh

stop-rate-limiter:
	@./rate-limiter/stop.sh

configure-traffic-manager:
	@./qos/configure.sh

set-priority:
	@./qos/set-priority.sh

clear-priority:
	@./qos/clear-priority.sh

ping:
	@ip netns exec client ping 17.0.0.1

.PHONY: load-balancer load-balancer-server1 load-balancer-server2 load-balancer-client stop-load-balancer
.PHONY: rate-limiter rate-limiter-server1 rate-limiter-client stop-rate-limiter
