#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

mkdir -p unix.build.crypto
cd unix.build.crypto

if [[ -f lib64/libcrypto.a ]]; then
	exit
fi

if [[ ! -d openssl/.git ]]; then
	if [[ -d ../win32.build.crypto/openssl ]]; then
		cp -r ../win32.build.crypto/openssl openssl
		cd openssl

		git reset --hard HEAD
		git clean -dxf
	else
		line=$(grep openssl ../.upstream)
		repo=$(cut -f2 <<< $line)
		tag=$(cut -f3 <<< $line)

		git clone --single-branch $repo
		cd openssl

		git fetch --tags origin master
		git reset --hard $tag
	fi

	cd ..
fi

mkdir -p build
cd build

feature='no-shared no-deprecated no-stdio no-sock'
option="--prefix=$PWD/.. --release"

../openssl/Configure $feature $option
make -j
make install_sw
