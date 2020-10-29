export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix
export NIX_PATH = nixpkgs=$(HOME)/.nix-defexpr/channels/nixpkgs:$(HOME)/.nix-defexpr/channels
export TMPDIR = $(shell scripts/nix-tmpdir)
export NIX_BUILD_SHELL = $(shell nix-build --no-out-link '<nixpkgs>' -A bash)/bin/bash

home-manager:
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install
	home-manager -I $(shell pwd) switch
	$(MAKE) post-install

build:
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install
	home-manager -I $(shell pwd) build

all: install-hooks cachix home-manager

deps:
	helpers/install-deps

post-install: system-icons

system-icons:
	./scripts/garcon-helper copy-icons

clean:
	sudo rm -rf /homeless-shelter

.PHONY: all home-manager system-icons clean \
	post-install \
	update-nix-channels init-home-manager
