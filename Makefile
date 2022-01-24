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
