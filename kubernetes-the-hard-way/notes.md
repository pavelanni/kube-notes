# Kubernetes the hard way notes

**2024-08-10**: created four ARM64-based server on Hetzner. Total prices is about E15.5/month. Not bad.

## Lessons learned

1. When in 03 Kelsey says `server.kubernetes.local` in the `machines.txt` you should enter it literally.
It's not your actual FQDN.
Same for `node-{0..1}`.
These names will be used in the configs later.
I made a mistake and entered my real FQDNs.
2. Hetzner by default creates public IPs for all nodes, but they all are in different subnets.
Because of that you won't be able to add pod network routes in 11.
You can to create a private network and attach each node to that network.
~~When creating a private network choose some other subnet instead of `10.0.0.0/16` the Hetzner proposes by default. It will conflict with the pod subnets 10.200.0.0/24 and .1.0/24 used later. Use something like 192.168.0.0/24.~~
3. Route adding commands proposed by Kelsey  `ip route add ${NODE_0_SUBNET} via ${NODE_0_IP}` didn't work for me.
Instead I had to use `ip route add ${NODE_0_SUBNET} via 192.168.0.1` (the default gateway of my private network) for both pod subnets.
4. The command to test the NodePort in the Smoke test section uses `node-0` but in my case the pod was placed to `node-1` and, of course, didn't respond on `node-0`.
5. The certificate sections definitely need diagrams: what is needed by what and where it's placed.

The rest went well.
