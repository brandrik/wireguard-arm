FROM arm32v7/debian

#RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
# printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable


RUN apt-get update && \
    apt-get upgrade  && \
    #apt-get install linux-headers-$(uname -r) && \
    echo "deb http://deb.debian.org/debian/ unstable main" |  tee --append /etc/apt/sources.list.d/unstable.list && \
    apt-get install -y dirmngr  && \
    apt-key adv --keyserver   keyserver.ubuntu.com --recv-keys 8B48AD6246925553  && \
    printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' | tee --append /etc/apt/preferences.d/limit-unstable
    
RUN apt-get update && \
    apt-get install -y wireguard && \ 
    apt-get install -y --no-install-recommends wireguard-tools iptables nano net-tools && \
    apt-get clean

RUN mkdir -p /scripts

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY scripts /scripts
RUN chmod 755 /scripts/*

ENTRYPOINT ["/scripts/run.sh"]
CMD []