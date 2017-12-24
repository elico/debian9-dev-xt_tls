FROM debian:stretch

#ADD	sources.list	/etc/apt/sources.list
#ENV http_proxy "http://213.151.33.10:3128"
#ENV https_proxy "http://213.151.33.10:3128"

RUN	apt-get update \
        && apt-get install netselect-apt -y \
	&& echo '1' \
        && netselect-apt -c il -n stretch \
	&& mv sources.list /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y apt-utils \
	&& apt-get upgrade -y \
	&& apt-get install -y linux-image-amd64 linux-headers-amd64 linux-source\
	&& apt-get install -y build-essential iptables-dev iptables conntrack libnetfilter-conntrack-dev libxtables-dev \
	&& apt-get install -y autoconf libtool git libpcap-dev libjson-c-dev \
	&& apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

RUN	apt-get install dkms debhelper dh-virtualenv -y

ADD	clean.sh /clean.sh

RUN	chmod +x /clean.sh \
	&& /bin/bash clean.sh

RUN mkdir /build
VOLUME /build
CMD ["/build/build.sh"]

