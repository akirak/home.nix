export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix
export NIX_PATH = nixpkgs=$(HOME)/.nix-defexpr/channels/nixpkgs:$(HOME)/.nix-defexpr/channels
export TMPDIR = $(shell scripts/nix-tmpdir)
export NIX_BUILD_SHELL = $(shell nix-build --no-out-link '<nixpkgs>' -A bash)/bin/bash

home-manager:
	home-manager -I $(shell pwd) switch
.PHONY: home-manager

build:
	home-manager -I $(shell pwd) build
.PHONY: build

init:
	home-manager -I $(shell pwd) install
.PHONY: init

deps:
	helpers/install-deps
.PHONY: deps

clean:
	sudo rm -rf /homeless-shelter
.PHONY: clean

lint-structure:
	./helpers/lint-structure
.PHONY: lint-structure
