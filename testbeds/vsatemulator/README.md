# vsatemulator

These are the configuration files for a dumbbell network that uses dummynet for
link emulation.

It looks like:


           client                  router                  server
      +-------------+         +-------------+         +-------------+
      |  +--+       |         |             |         |       +--+  |
      |  |vm|<--->if+<------->+if         if+<------->+if<--->|vm|  |
      |  +--+       |         |             |         |       +--+  |
      |   ^         |         |             |         |         ^   |
      |   v if      |         |      if     |         |      if v   |
      +------+------+         +------+------+         +------+------+
             |                       |                       |       
             |                       |                       |       
             |                       |                       |       
             v                       v                       v
                              
                              Upstream network

The testbed described here was realised using three PcEnginges APU2 boards.
Client and server acted as testnodes for FreeBSD based experiemnets and a vm
hosts for debian virtual machines using bhyve for Linux based experiments.

The vm part of this wasn't automated and they vms were launched using shell scripts.

The scripts in `scripts` control the router configuration and run tests.
