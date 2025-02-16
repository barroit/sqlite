# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = 'Stop'

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

echo $vcvars
