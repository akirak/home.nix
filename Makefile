export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix
export NIX_PATH = nixpkgs=$(HOME)/.nix-defexpr/channels/nixpkgs:$(HOME)/.nix-defexpr/channels
export TMPDIR = $(shell scripts/nix-tmpdir)
export NIX_BUILD_SHELL = $(shell nix-build --no-out-link '<nixpkgs>' -A bash)/bin/bash

home-manager:
	home-manager -I $(shell pwd) switch

build:
	home-manager -I $(shell pwd) build

all: install-hooks cachix home-manager

deps:
	helpers/install-deps

clean:
	sudo rm -rf /homeless-shelter

.PHONY: all home-manager build all clean
