FROM arm32v7/debian

RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
 printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable

RUN apt update && \
 apt install -y --no-install-recommends wireguard-tools iptables nano net-tools && \
 apt clean

RUN mkdir -p /scripts

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY scripts /scripts
RUN chmod 755 /scripts/*

ENTRYPOINT ["/scripts/run.sh"]
CMD []