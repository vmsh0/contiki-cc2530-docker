## Contiki CC2530DK Docker Image

This repository contains a simple Docker image containing the [Contiki IoT operating
system](https://github.com/contiki-os/contiki) port for TI's CC2530DK platform, along with the
necessary tools to use it (essentially [sdcc](https://sdcc.sourceforge.net/),
[srecord](https://srecord.sourceforge.net/), and GNU Make). The same image is available in Docker
Hub at [vmsh0/cc2530-contiki](https://hub.docker.com/r/vmsh0/cc2530-contiki).

This repository *does not* contain the necessary software to flash the resulting programs to
CC2530DK boards. As far as I know, the only way to do that is to use [TI's SmartRF Flash
Programmer](https://www.ti.com/tool/FLASH-PROGRAMMER) (specifically the first version). I cannot
redistribute that, but I plan to include instructions on how to use it at a later time.

### Getting Started

(work in progress)

