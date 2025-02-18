# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = 'Stop'

if (!(Test-Path win32.build.jom)) {
	$line = Select-String -Raw -NoEmphasis `
			      -Path ./.upstream -Pattern jom
	$line = $line -split '\t'

	$url = $line | Select-Object -Index 1

	mkdir win32.build.jom
	cd win32.build.jom

	curl -L -o jom.zip $url
	Expand-Archive -DestinationPath . jom.zip

	rm jom.zip
}

cd ..
