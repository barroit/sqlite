#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

mkdir -p build.crypto
cd build.crypto

if [[ -f lib64/libcrypto.a ]]; then
	exit
fi

if [[ ! -d openssl/.git ]]; then
	line=$(grep openssl ../.upstream)
	repo=$(cut -f2 <<< $line)
	branch=$(cut -f3 <<< $line)

	git clone --single-branch --branch=$branch $repo
fi

mkdir -p build
cd build

feature='no-shared no-deprecated no-stdio'
option="--prefix=$PWD/.. --release"

../openssl/Configure $feature $option
make -j
make install_sw
