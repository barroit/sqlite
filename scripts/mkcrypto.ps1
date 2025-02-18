# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = 'Stop'

if (!(Test-Path win32.build.jom)) {
	./scripts/mkjom.ps1
}

if (!(Test-Path win32.build.crypto)) {
	mkdir win32.build.crypto
}
cd win32.build.crypto

if (Test-Path lib/libcrypto.lib) {
	cd ..
	exit
}

if (!(Test-Path openssl/.git)) {
	if (Test-Path ../unix.build.crypto/openssl) {
		cp -recurse ../unix.build.crypto/openssl openssl
		cd openssl

		git reset --hard HEAD
		git clean -dxf
	} else {
		$line = Select-String -Raw -NoEmphasis `
				      -Path ../.upstream -Pattern openssl
		$line = $line -split '\t'

		$repo = $line | Select-Object -Index 1
		$tag = $line | Select-Object -Index 2

		git clone --single-branch $repo
		cd openssl

		git fetch --tags origin master
		git reset --hard $tag
	}

	cd ..
}

$vcvars = ../scripts/findvcvars.ps1
$jom    = '../../win32.build.jom/jom.exe'

if (!(Test-Path build)) {
	mkdir build
}
cd build

$feature = 'no-shared', 'no-deprecated', 'no-stdio', 'no-sock'
$option = "--prefix=$PWD/..", '--release'
$cpu = $env:NUMBER_OF_PROCESSORS
$target = 'build_sw install_sw'

perl ../openssl/Configure CFLAGS='/FS' @feature @option
cmd /c "`"$vcvars`" amd64 && `"$jom`" -j$cpu $target"

cd ../..
