# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = 'Stop'

if (!(Test-Path build.jom)) {
	./scripts/mkjom.ps1
}

if (!(Test-Path build.crypto)) {
	mkdir build.crypto
}
cd build.crypto

if (Test-Path lib/libcrypto.lib) {
	cd ..
	exit
}

if (!(Test-Path openssl/.git)) {
	$line = Select-String -Raw -NoEmphasis `
			      -Path ../.upstream -Pattern openssl
	$line = $line -split '\t'

	$repo = $line | Select-Object -Index 1
	$tag = $line | Select-Object -Index 2

	git clone --single-branch $repo
	cd openssl

	git fetch --tags origin master
	git reset --hard $tag

	cd ..
}

$vcvars = ../scripts/findvcvars.ps1

if (!(Test-Path build)) {
	mkdir build
}
cd build

$feature = 'no-shared', 'no-deprecated', 'no-stdio', 'no-sock'
$option = "--prefix=$PWD/..", '--release'
$cpu = $env:NUMBER_OF_PROCESSORS
$target = 'build_sw install_sw'

perl ../openssl/Configure CFLAGS='/FS' @feature @option
cmd /c "`"$vcvars`" amd64 && `"../../build.jom/jom.exe`" -j$cpu $target"

cd ../..
