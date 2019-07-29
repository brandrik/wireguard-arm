#FROM arm32v7/debian

#RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
# printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable


# RUN apt-get update && \
#     apt-get upgrade  && \
#     #apt-get install linux-headers-$(uname -r) && \
#     echo "deb http://deb.debian.org/debian/ unstable main" |  tee --append /etc/apt/sources.list.d/unstable.list && \
#     apt-get install -y dirmngr  && \
#     apt-key adv --keyserver   keyserver.ubuntu.com --recv-keys 8B48AD6246925553  && \
#     printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' | tee --append /etc/apt/preferences.d/limit-unstable
    
# RUN apt-get update && \
#     apt-get install -y wireguard && \ 
#     apt-get install -y --no-install-recommends wireguard-tools iptables nano net-tools && \
#     apt-get clean


FROM arm32v7/alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN apk add --no-cache \
	build-base \
	ca-certificates \
	elfutils-libelf \
	libmnl-dev \nano \
    alpine-sdk \ 
    gcc wget \ 
    make  \
    #apk add linux-hardened-dev && \ 
    libmnl-dev

# https://git.zx2c4.com/WireGuard/refs/
ENV WIREGUARD_VERSION 0.0.20190702

RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		git \
	&& git clone --depth 1 --branch "${WIREGUARD_VERSION}" https://git.zx2c4.com/WireGuard.git /wireguard \
	&& ( \
		cd /wireguard/src \
		&& make tools \
		&& make -C tools install \
		&& make -C tools clean \
	) 
    #\
	#&& apk del .build-deps
CMD "ls -lh /wireguard/src" 

COPY entrypoint.sh "/usr/local/bin/entrypoint.sh"

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "wg", "--help" ]

# Install make

# RUN wget https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190702.tar.xz && \
#     git clone https://git.zx2c4.com/WireGuard

# RUN cd WireGuard/src && \
#     make && \
#     make install


# RUN mkdir -p /scripts

# WORKDIR /scripts
# ENV PATH="/scripts:${PATH}"
# COPY scripts /scripts
# RUN chmod 755 /scripts/*

# ENTRYPOINT ["/scripts/run.sh"]
# CMD []