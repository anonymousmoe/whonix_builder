#!/bin/bash

set -e

sudo -u user /bin/bash -c "{ mkdir -p ~/logs && wget https://www.whonix.org/keys/derivative.asc -O ~/derivative.asc && \
	gpg --keyid-format long --import --import-options show-only --with-fingerprint ~/derivative.asc && \
	gpg --import ~/derivative.asc && gpg --check-sigs 916B8D99C38EAF5E8ADC7A2A8D66066A2EEACCDA; } | tee ~/logs/key.log && \
	{ cd ~/ && git clone --depth=1 --branch ${WHONIX_TAG} \
	--jobs=4 --recurse-submodules --shallow-submodules https://github.com/Whonix/derivative-maker.git && \
	cd ~/derivative-maker; git fetch && git verify-tag ${WHONIX_TAG} &>> ~/logs/git.log && \
	git verify-commit ${WHONIX_TAG}^{commit} &>> ~/logs/git.log && git checkout --recurse-submodules ${WHONIX_TAG} &>> ~/logs/git.log && \
	git describe && git status; } | tee -a ~/logs/git.log && \
	{ tbb_version=${TBB_VERSION} ~/derivative-maker/derivative-maker \
	--flavor ${FLAVOR_WS} --target ${TARGET} --arch ${ARCH} --repo ${REPO} | tee ~/logs/build_ws.log && \
	tbb_version=${TBB_VERSION} ~/derivative-maker/derivative-maker \
	--flavor ${FLAVOR_GW} --target ${TARGET} --arch ${ARCH} --repo ${REPO} | tee ~/logs/build_gw.log; }"				
