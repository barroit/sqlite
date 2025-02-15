#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

NDEBUG=$1
opts='--disable-math --disable-json --disable-load-extension'

if [[ -z $NDEBUG ]]; then
	opts+=' --debug'
fi

mkdir -p build
cd build

../configure --crypto $opts

make -j sqlite3.c sqlite3.h

if [[ -z $NDEBUG ]]; then
	make -j sqlite3
fi
