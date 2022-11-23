## Contiki CC2530DK Docker Image

This repository contains a simple Docker image containing the [Contiki IoT operating
system](https://github.com/contiki-os/contiki) port for TI's CC2530DK platform, along with the
necessary tools to use it (essentially [sdcc](https://sdcc.sourceforge.net/),
[srecord](https://srecord.sourceforge.net/), and GNU Make). The same image is available in Docker
Hub at [vmsh0/cc2530-contiki](https://hub.docker.com/r/vmsh0/cc2530-contiki).

This repository *does not* contain the necessary software to flash the resulting programs to
CC2530DK boards. There are two ways to do that:

- On Windows, use [TI's SmartRF Flash Programmer](https://www.ti.com/tool/FLASH-PROGRAMMER)
  (specifically the first version). It also has a command-line mode, which is documented in some
  technical document somewhere on TI's website (if you come across it, open an Issue an link it, so
  I can add it here.)
- On Linux and Mac OS X, use [cc-tool](https://github.com/dashesy/cc-tool)

### Getting Started

Assuming you are on Linux, and that you have Docker (or, even better, [Podman](https://podman.io/))
installed, you can get started in just a few minutes.

#### Compiling an example

For a test ride, you can clone the [Contiki CC2530 port
repository](https://github.com/vmsh0/contiki-sensinode) (the same one that's used inside the Docker
image) and go into the `examples/cc2530dk` directory.

A small change to the Makefile is needed before the container can be used to build the projects. The
existing one defines the `CONTIKI` environment variable to `../..`. However, inside the image, that
is not correct. You can just delete or comment out the line, or you can change it to `CONTIKI ?=
../..`. Either solution will work fine, as inside the container the `CONTIKI` variable is
automatically set to the correct value. 

After that, you can use the `wrap.sh` script provided in this repository. The script will simply
spawn a one-off (`--rm`) container, bind-mount the current directory to `/mnt` inside of it, change
to that directory, and execute the command you pass to it. In other words, once you're in the
`examples/cc2530dk` directory on your host machine and have fixed the Makefile as instructed, just
run:

```
./wrap.sh make
```

The first time you run the script, provided you haven't manually pulled the container image yet, it
will do that, thus taking a bit of time to complete. After that, the overhead of running the script
will be pretty minimal. On my resonably recent laptop, using Podman:

```
➜ time ./wrap.sh
sh: 1: Syntax error: end of file unexpected
./wrap.sh  0.06s user 0.04s system 34% cpu 0.296 total
```

The script uses the first command it finds among `podman` and `docker` to spawn the container.

#### Flashing setup

Start by compiling and installing [cc-tool](https://github.com/dashesy/cc-tool) (Ubuntu has a
package, and one is also available for Arch Linux on the AUR). After that's done, check that it
correctly recognizes your programmer and target by giving `sudo cc-tool -t`. If that doesn't work
and only shows the programmer (i.e. not the target), unplug and plug in the programmer again, power
cycling it. Your output should resemble the following:

```
  Programmer: SmartRF04EB
  Target: CC2530
  Device info:
   Name: SmartRF04EB
   Debugger ID: 0050
   Version: 0x0400
   Revision: 0x0047

  Target info:
   Name: CC2530
   Revision: 0x24
   Internal ID: 0xA5
   ID: 0x2530
   Flash size: 256 KB
   Flash page size: 2
   RAM size: 8 KB
   Lock data size: 16 B
```

Then, just flash one of the examples you have just compiled, such as `blink-hello.hex`:

```
sudo cc-tool -e -w blink-hello.hex
```

This should finish pretty quickly, and your board should start flashing its on-board LED.

