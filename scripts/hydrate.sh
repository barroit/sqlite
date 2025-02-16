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
	opts='--disable-math --disable-json --disable-load-extension'

	if [[ ! $release ]]; then
		opts+=' --debug'
	fi

	../configure --crypto --with-local-crypto $opts
fi

target='sqlite3.c sqlite3.h'

if [[ $exe ]]; then
	target+=' sqlite3'
fi

make -j $target
