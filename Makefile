P4C :=

start:
	@./scripts/start-infra.sh

compile:
	@make -f ${P4C_REPO}/backends/ebpf/runtime/kernel.mk BPFOBJ=out.o P4FILE=demo.p4 ARGS="-DPSA_PORT_RECIRCULATE=2" psa

deploy:
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline load id 1 out.o
	@echo "Adding ports to switch..."
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline add-port id 1 psa_recirc
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline add-port id 1 eth0
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline add-port id 1 eth1
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline add-port id 1 eth2
	@echo "Ports successfully added"
	@sudo scripts/routing.sh
	@echo "Done"

clean:
	@sudo nsenter --net=/var/run/netns/switch psabpf-ctl pipeline unload id 1 || true
	@./scripts/stop-infra.sh || true
	@rm out.* || true

.PHONY: start compile deploy clean

load-balancer:
	@sudo ./load-balancer/start.sh

load-balancer-server1:
	@sudo ip netns exec server1 ./load-balancer/server.py

load-balancer-server2:
	@sudo ip netns exec server2 ./load-balancer/server.py

load-balancer-client:
	@sudo ip netns exec client ./load-balancer/client.sh

stop-load-balancer:
	@sudo ./load-balancer/stop.sh

rate-limiter:
	@sudo ./rate-limiter/start.sh

rate-limiter-server1:
	@sudo ip netns exec server1 ./rate-limiter/server.sh

rate-limiter-client:
	@sudo ip netns exec client ./rate-limiter/client.sh

stop-rate-limiter:
	@sudo ./rate-limiter/stop.sh

.PHONY: load-balancer load-balancer-server1 load-balancer-server2 load-balancer-client stop-load-balancer
.PHONY: rate-limiter rate-limiter-server1 rate-limiter-client stop-rate-limiter
