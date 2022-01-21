P4C :=

start:
	@./scripts/start-infra.sh

compile:
	@make -f ${P4C}/backends/ebpf/runtime/kernel.mk BPFOBJ=out.o P4FILE=demo.p4 P4C="p4c-ebpf --arch psa" ARGS="-DBTF -DPSA_PORT_RECIRCULATE=2"

deploy:
	@ip netns exec switch psabpf-ctl pipeline load id 1 out.o
	@ip netns exec switch psabpf-ctl pipeline add-port id 1 eth0
	@ip netns exec switch psabpf-ctl pipeline add-port id 1 eth1
	@ip netns exec switch psabpf-ctl pipeline add-port id 1 eth2

clean:
	@ip netns exec switch psabpf-ctl pipeline unload id 1
	@./scripts/stop-infra.sh
	@rm out.c out.o

.PHONY: start compile deploy clean