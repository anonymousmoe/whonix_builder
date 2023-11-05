#!/bin/bash

set -e

### if APT_ONION true ###
	${APT_ONION} && ONION="--connection onion" && mv /50_user.conf /lib/systemd/system/apt-cacher-ng.service.d/50_user.conf && \
	printf "PassThroughPattern: .*\nBindAddress: localhost\nSocketPath: /run/apt-cacher-ng/socket\nPort:3142\nProxy: http://127.0.0.1:3142\nAllowUserPorts: 0" \
	>> /etc/apt-cacher-ng/acng.conf && echo "Acquire::BlockDotOnion \"false\";" > /etc/apt/apt.conf.d/30user && \
	systemctl daemon-reload && systemctl start tor.service && \
	systemctl restart apt-cacher-ng.service && systemctl status apt-cacher-ng.service && sleep 1

### start dnscrypt service ###
sudo -u user /bin/bash -c '{ mkdir -p ~/logs && sudo systemctl start dnscrypt-proxy.service && \
	sudo systemctl status dnscrypt-proxy.service && sleep 1; }'

### start whonix build ###
sudo -u user /bin/bash -c "{ wget https://www.whonix.org/keys/derivative.asc -O ~/derivative.asc && \
	gpg --keyid-format long --import --import-options show-only --with-fingerprint ~/derivative.asc && \
	gpg --import ~/derivative.asc && gpg --check-sigs 916B8D99C38EAF5E8ADC7A2A8D66066A2EEACCDA; } | tee ~/logs/key.log && \
	{ cd ~/ && git clone --depth=1 --branch ${WHONIX_TAG} \
	--jobs=4 --recurse-submodules --shallow-submodules https://github.com/Whonix/derivative-maker.git && \
	cd ~/derivative-maker; git fetch && git verify-tag ${WHONIX_TAG} &>> ~/logs/git.log && \
	git verify-commit ${WHONIX_TAG}^{commit} &>> ~/logs/git.log && git checkout --recurse-submodules ${WHONIX_TAG} &>> ~/logs/git.log && \
	git describe && git status; } | tee -a ~/logs/git.log && \
	{ tbb_version=${TBB_VERSION} ~/derivative-maker/derivative-maker \
	--flavor ${FLAVOR_WS} --target ${TARGET} --arch ${ARCH} --repo ${REPO} ${ONION} | tee ~/logs/build_ws.log && \
	tbb_version=${TBB_VERSION} ~/derivative-maker/derivative-maker \
	--flavor ${FLAVOR_GW} --target ${TARGET} --arch ${ARCH} --repo ${REPO} ${ONION} | tee ~/logs/build_gw.log; }"				
