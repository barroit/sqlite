# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = 'Stop'

if (!(Test-Path build.crypto)) {
	./scripts/mkcrypto.ps1
}

if ($args -match '--release') {
	$release = 1
}

if ($args -match '--exe') {
	$exe = 1
}

if (!(Test-Path build)) {
	mkdir build
}
cd build

$vcvars = ../scripts/findvcvars.ps1
$option = 'TOP=.. USE_CRYPTO=1'
$target = 'libsqlite3.lib'

if (!$release) {
	$option += ' DEBUG=3'
}

if ($exe) {
	$target = 'sqlite3.exe'
}

cmd /c "`"$vcvars`" amd64 && nmake /f ../Makefile.msc $option $target"

cd ..

if (Test-Path install || $exe) {
	exit
}

mkdir install, install/lib, install/include
cp build/libsqlite3.lib install/lib
cp build/sqlite3.h, build/sqlite3ext.h install/include
