#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

if grep -q -- distclean <<< $@; then
	cd unix.build.crypto
	rm -rf ../unix.install ../unix.build bin build include lib*
	exit
fi

if [[ ! -d unix.build.crypto/include ]]; then
	./scripts/mkcrypto.sh
fi

if grep -q -- --release <<< $@; then
	release=1
fi

if grep -q -- --no-configure <<< $@; then
	no_configure=1
fi

if grep -q -- --exe <<< $@; then
	exe=1
fi

if grep -q -- --configure-only <<< $@; then
	configure_only=1
fi

mkdir -p unix.build
cd unix.build

if [[ ! $no_configure ]]; then
	if [[ -f Makefile ]]; then
		make distclean
	fi

	option='--disable-math --disable-json --disable-load-extension'

	if [[ ! $release ]]; then
		option+=' --debug'
	fi

	if [[ ! $exe ]]; then
		option+=" --prefix=$PWD/../unix.install"
	fi

	../configure --crypto --with-local-crypto $option

	if [[ $configure_only ]]; then
		exit
	fi
fi

target='install-lib install-so install-headers'

if [[ $exe ]]; then
	target='sqlite3'
fi

make -j $target
