#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

if git remote | grep -q sqlite; then
	git switch sqlite
	git pull sqlite master
else
	url=$(grep sqlite .upstream | cut -f2)

	git remote add sqlite $url
	git fetch sqlite master
	git checkout -b sqlite sqlite/master
fi

git switch master
git rebase --onto sqlite $(git merge-base master sqlite) master
