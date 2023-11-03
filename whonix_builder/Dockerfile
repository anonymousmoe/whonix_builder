FROM debian:bookworm as baseimage

	### enable https sources ###
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates && \
	echo "deb https://deb.debian.org/debian bookworm main contrib" > /etc/apt/sources.list && \
	rm -f /etc/apt/sources.list.d/debian.sources && \
	apt-get update && apt-get install -y systemd systemd-sysv dbus dbus-user-session git \
	time curl lsb-release fakeroot dpkg-dev fasttrack-archive-keyring \
	apt-utils wget procps debian-keyring sudo adduser && \
	### apt-cacher-ng ###	
	echo no | apt-get install -y apt-cacher-ng && \	
	chmod 777 /var/cache/apt-cacher-ng && \
	echo "PassThroughPattern: .*" >> /etc/apt-cacher-ng/acng.conf && \
	### clean up ###
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	rm -f /lib/systemd/system/multi-user.target.wants/* && \
	rm -f /etc/systemd/system/*.wants/* && \
	rm -f /lib/systemd/system/local-fs.target.wants/* && \
	rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
	rm -f /lib/systemd/system/basic.target.wants/* && \
	rm -f /lib/systemd/system/anaconda.target.wants/* && \
	rm -f /lib/systemd/system/plymouth* && \
	rm -f /lib/systemd/system/systemd-update-utmp* && \
	### user account ###
	adduser --quiet --disabled-password --home /home/user --gecos 'user,,,,' user && \
	echo "user:super" | chpasswd && \
	sudo adduser user sudo

FROM baseimage

ENV WHONIX_TAG="17.0.5.9-developers-only"
ENV TBB_VERSION="13.0.1"
ENV FLAVOR_GW="whonix-gateway-cli"
ENV FLAVOR_WS="whonix-workstation-cli"
ENV TARGET="raw"
ENV ARCH="amd64"
ENV REPO="true"

COPY systemd_init.sh whonix_starter.sh /

VOLUME [ "/home/user" ]

ENTRYPOINT ["/systemd_init.sh","/whonix_starter.sh"]
