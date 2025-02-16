#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

if [[ ! -d build.crypto ]]; then
	./scripts/mkcrypto.sh
fi

if grep -q -- --release <<< $@; then
	release=1
fi

if grep -q -- --fast <<< $@; then
	fast=1
fi

mkdir -p build
cd build

if [[ ! $fast ]]; then
	opts='--disable-math --disable-json --disable-load-extension'

	if [[ ! $release ]]; then
		opts+=' --debug'
	fi

	../configure --crypto --with-local-crypto $opts
fi

make -j sqlite3.c sqlite3.h

if [[ ! $release ]]; then
	make -j sqlite3
fi
