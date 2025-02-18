# SPDX-License-Identifier: GPL-3.0-or-later

.PHONY: build configure all

build:
	./scripts/hydrate.sh --no-configure

configure:
	./scripts/hydrate.sh --configure-only

all: configure build
