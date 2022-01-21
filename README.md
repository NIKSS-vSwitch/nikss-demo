# PSA-eBPF demo

## Steps to run demo

Install the following packages on your Linux OS:

```
apt install curl 
```

Boot up the demo infrastructure:

```bash
make start
```

The above script will create 4 Linux namespaces: `switch`, `client`, `server1`, `server2`.

Compile the P4 program (replace path to p4c-ebpf:

```bash
make P4C=../p4c-ebpf-psa compile
```

Deploy PSA-eBPF program and insert eBPF programs:

```bash
make deploy
```

