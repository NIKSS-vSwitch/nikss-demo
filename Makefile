P4C :=

start:
	@./scripts/start-infra.sh

compile:
	@make -f ${P4C_REPO}/backends/ebpf/runtime/kernel.mk BPFOBJ=demo.o P4FILE=demo.p4 ARGS="-DPSA_PORT_RECIRCULATE=2" P4ARGS="--Wdisable=unused" psa

deploy:
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline load id 1 demo.o
	@echo "Adding ports to switch..."
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl add-port pipe 1 dev psa_recirc
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl add-port pipe 1 dev eth0
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl add-port pipe 1 dev eth1
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl add-port pipe 1 dev eth2
	@echo "Ports successfully added"
	@sudo scripts/routing.sh
	@echo "Done"

clean:
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline unload id 1 || true
	@./scripts/stop-infra.sh || true
	@rm demo.* || true

.PHONY: start compile deploy clean

load-balancer:
	@sudo ./load-balancer/start.sh

http-server-1:
	@sudo ip netns exec server1 ./load-balancer/server.py

http-server-2:
	@sudo ip netns exec server2 ./load-balancer/server.py

http-client:
	@sudo ip netns exec client ./load-balancer/client.sh

stop-load-balancer:
	@sudo ./load-balancer/stop.sh

rate-limiter:
	@sudo ./rate-limiter/start.sh

iperf-server:
	@sudo ip netns exec server1 ./rate-limiter/server.sh

iperf-client:
	@sudo ip netns exec client ./rate-limiter/client.sh

stop-rate-limiter:
	@sudo ./rate-limiter/stop.sh

configure-traffic-manager:
	@sudo ./qos/configure.sh

set-priority:
	@sudo ./qos/set-priority.sh

clear-priority:
	@sudo ./qos/clear-priority.sh

ping:
	@sudo ip netns exec client ping 17.0.0.1

.PHONY: load-balancer load-balancer-server1 load-balancer-server2 load-balancer-client stop-load-balancer
.PHONY: rate-limiter rate-limiter-server1 rate-limiter-client stop-rate-limiter
