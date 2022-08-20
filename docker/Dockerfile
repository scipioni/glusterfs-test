FROM ubuntu:22.04


ENV GW=""

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y iproute2 inetutils-ping curl host mtr-tiny tcpdump iptables
RUN apt-get install -y glusterfs-server \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /

VOLUME /var/lib/glusterd

# For client communication 49152-49251
EXPOSE 24007 24008 49152 49153 49154 49155 49156 49157

#ENTRYPOINT /entrypoint.sh
CMD /entrypoint.sh $GW