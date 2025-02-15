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
	$branch = $line | Select-Object -Index 2

	git clone --single-branch --branch=$branch $repo
}

$vcvars_prefix = @(
	'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools',
	'C:\Program Files\Microsoft Visual Studio\2022\Community',
	'C:\Program Files\Microsoft Visual Studio\2022\Professional'
)

if (!$args[0]) {
	foreach ($prefix in $vcvars_prefix) {
		$vcvars = "$prefix\VC\Auxiliary\Build\vcvarsall.bat"

		if (Test-Path $vcvars) {
			break;
		}

		Remove-Variable vcvars
	}
} elseif (Test-Path $args[0]) {
	$vcvars = $args[0]
}

if (!$vcvars) {
	Write-Error 'findvcvars.ps1 requires a valid vcvarsall.bat path'
}

if (!(Test-Path build)) {
	mkdir build
}
cd build

$feature = 'no-shared', 'no-deprecated', 'no-stdio'
$option = "--prefix=$PWD/..", '--release'
$cpu = $env:NUMBER_OF_PROCESSORS
$target = 'build_sw install_sw'

perl ../openssl/Configure CFLAGS='/FS' @feature @option
cmd /c "`"$vcvars`" amd64 && `"../../build.jom/jom.exe`" -j$cpu $target"

cd ../..
