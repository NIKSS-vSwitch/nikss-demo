# PSA-eBPF demo

## Steps to run demo

Run the docker image with p4c compiler and nikss-ctl installed:

```
docker run -it --privileged --rm -v "$(pwd)":/nikss osinstom/nikss
```

Boot up the demo infrastructure:

```bash
make start
```

The above script will create 4 Linux namespaces: `switch`, `client`, `server1`, `server2`.

Compile the P4 program (replace path to p4c repository):

```bash
make compile
```

Deploy PSA-eBPF program and insert eBPF programs with forwarding rules (no virtual IP yet):

```bash
make deploy
```

## Load-balancing

Set up rules for load-balancing and server virtual IP address:
```bash
make load-balancer
```

Run HTTP servers, one in every container. Issue these commands, every in separate terminal:
```bash
make http-server-1
make http-server-2
```

Run client, which makes some requests to the server(s) on virtual IP:
```bash
make http-client
```
This should take about 20 second to execute. When client stops, stop servers with
Ctrl-C to see number of processed requests per server.

Disaable load-balancer and remove virtual IP:
```bash
make stop-load-balancer
```

## Rate-limiter
Set up a meter rule:
```bash
make rate-limiter
```
Run iperf server on server no. 1:
```bash
make iperf-server
```

Run iperf client and observe results:
```bash
make iperf-client
```

To remove meter rule:
```bash
make stop-rate-limiter
```

## Traffic prioritization

Configure traffic manager (*tc qdisc*) with QoS classes and treatment.

```
make configure-traffic-manager
```

Start ping between client and server1:

```
make ping
```

Create congestion on the link between client and server1:

```
make iperf-server
make iperf-client
```

Set priority for ICMP traffic:

```
make set-priority
```

Clear priority for ICMP traffic:

```
make clear-priority
```
