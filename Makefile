export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix
export NIX_PATH = nixpkgs=$(HOME)/.nix-defexpr/channels/nixpkgs:$(HOME)/.nix-defexpr/channels
export TMPDIR = $(shell scripts/nix-tmpdir)
export NIX_BUILD_SHELL = $(shell nix-build --no-out-link '<nixpkgs>' -A bash)/bin/bash

home-manager: tangle deps
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install
	home-manager -I $(shell pwd) switch
	$(MAKE) post-install

tangle:
	if command -v emacs >/dev/null 2>&1; then \
		emacs --batch --eval "(progn (require 'ob) (org-babel-tangle-file \"README.org\"))"; \
	fi

build: tangle
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install
	home-manager -I $(shell pwd) build

all: install-hooks chemacs cachix home-manager lorri myrepos-checkout

deps: fuse etc

fuse:
	if grep --silent -P "ID(_LIKE)?=debian" /etc/os-release \
		&& ! which fusermount >/dev/null 2>&1; then \
		sudo apt-get install --yes fuse; \
	fi

etc:
	echo "Creating /etc/hosts with the following content"
	if [ ! -f /etc/hosts ]; then \
		echo "127.0.0.1	localhost $(uname -n)" | sudo tee /etc/hosts; \
		echo "::1 localhost ip6-localhost ip6-loopback" | sudo tee -a /etc/hosts; \
	fi

	echo "Creating an empty /etc/services"
	if [ ! -f /etc/services]; then \
		sudo touch /etc/services; \
	fi

post-install: system-icons chsh

system-icons:
	garcon-helper copy-icons

chsh:
	scripts/chsh-zsh

myrepos-checkout:
	if [ ! -f "$(HOME)/.mrconfig" ]; then exit 1; fi
	cd $(HOME)
	if [ -z "$(NO_MR_CHECKOUT)" ]; then mr checkout; fi

chemacs:
	cd contrib/chemacs && bash install.sh

	if [ ! -f "$(HOME)/.emacs-profiles.el" ]; then \
		install -m 644 -t "$(HOME)" -v dotfiles/.emacs-profiles.el; \
	fi

	if [ ! -f "$(HOME)/.custom.el" ]; then \
		touch "$(HOME)/.custom.el"; \
	fi

cachix:
	if ! command -v cachix 2>&1 >/dev/null; then \
		nix-env -iA cachix -f https://cachix.org/api/v1/install; \
	fi

lorri:
	if ! command -v lorri >/dev/null 2>&1; then \
		scripts/install-lorri; \
	fi

install-hooks:
	if [ -e .git ]; then nix-shell -p git --run 'git config core.hooksPath .githooks'; fi

clean:
	sudo rm -rf /homeless-shelter

.PHONY: install-hooks all chemacs home-manager system-icons clean \
	chsh update-nix-channels init-home-manager lorri tangle \
	myrepos-checkout cachix
