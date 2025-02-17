#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

if [[ ! -d build.crypto ]]; then
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

mkdir -p build
cd build

if [[ ! $no_configure ]]; then
	if [[ -f Makefile ]]; then
		make distclean
	fi

	option='--disable-math --disable-json --disable-load-extension'

	if [[ ! $release ]]; then
		option+=' --debug'
	fi

	if [[ ! $exe ]]; then
		option+=" --prefix=$PWD/../install"
	fi

	../configure --crypto --with-local-crypto $option
fi

target='libsqlite3.a install-lib install-headers'

if [[ $exe ]]; then
	target='sqlite3'
fi

make -j $target
