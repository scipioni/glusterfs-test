FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y glusterfs-server

COPY ["entrypoint.sh", "/"]


VOLUME ["/var/lib/glusterd"]

# For client communication 49152-49251
EXPOSE 24007 24008 49152 49153 49154 49155 49156 49157

#ENTRYPOINT /entrypoint.sh
CMD /entrypoint.sh