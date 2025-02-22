# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = 'Stop'

if ($args -match 'distclean') {
	cd win32.build.crypto
	rm -Recurse -Force -ErrorAction SilentlyContinue`
	   ../win32.install, ../win32.build, bin, build, include, lib*
	cd ..
	exit
}

if (!(Test-Path win32.build.crypto/include)) {
	./scripts/mkcrypto.ps1
}

if ($args -match '--release') {
	$release = 1
}

if ($args -match '--exe') {
	$exe = 1
}

if (!(Test-Path win32.build)) {
	mkdir win32.build
}
cd win32.build

$vcvars = ../scripts/findvcvars.ps1
$option = 'TOP=.. USE_CRYPTO=1'
$target = 'libsqlite3.lib sqlite3.dll'

if (!$release) {
	$option += ' DEBUG=3'
}

if ($exe) {
	$target = 'sqlite3.exe'
}

cmd /c "`"$vcvars`" amd64 && nmake /f ../Makefile.msc $option $target"

cd ..

if (Test-Path win32.install || $exe) {
	exit
}

mkdir win32.install, win32.install/lib, `
      win32.install/bin, win32.install/include

cp win32.build/libsqlite3.lib win32.install/lib
cp win32.build/sqlite3.dll win32.install/bin
cp win32.build/sqlite3.h, win32.build/sqlite3ext.h win32.install/include
