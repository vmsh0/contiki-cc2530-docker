LABEL org.opencontainers.image.source="https://github.com/vmsh0/contiki-cc2530-docker" \
      org.opencontainers.image.title="cc2530-contiki" \
      org.opencontainers.image.description="A Docker image for the CC2530DK Contiki port" \
      org.opencontainers.image.licenses=MIT

FROM debian:bullseye-slim

ARG SDCC_REV=9092

ENV CONTIKI=/contiki

COPY sdcc.patch /sdcc.patch
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential make flex bison python3 libboost-graph-dev srecord \
                       subversion git && \
    svn co -r $SDCC_REV svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc && \
    cd /sdcc && \
    patch -p0 < /sdcc.patch && \
    ./configure --disable-gbz80-port --disable-z80-port --disable-ds390-port --disable-ds400-port \
                --disable-pic14-port --disable-pic16-port --disable-hc08-port --disable-r2k-port \
                --disable-z180-port --disable-sdcdb --disable-ucsim --disable-r3ka-port \
                --disable-s08-port --disable-tlcs90-port --disable-stm8-port \
                --disable-werror && \
    make && \
    make install && \
    cd / && \
    rm -rf /sdcc /sdcc.patch && \
    git clone https://github.com/vmsh0/contiki-sensinode.git /contiki
RUN apt-get purge -y build-essential flex bison python3 libboost-graph-dev subversion git && \
    apt-get --purge -y autoremove && \
    apt-get clean

CMD bash

