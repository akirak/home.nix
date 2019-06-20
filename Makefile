export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

home-manager: tangle deps
	home-manager -I $(shell pwd) switch
	$(MAKE) post-install

tangle:
	if command -v emacs >/dev/null 2>&1; then \
		emacs --batch --eval "(require 'org-babel) (org-babel-tangle-file \"README.org\")"; \
	fi

deps: fuse

fuse:
	if grep --silent -P "ID(_LIKE)?=debian" /etc/os-release \
		&& ! which fusermount >/dev/null 2>&1 \
		&& ./scripts/is-wsl; then \
		sudo apt-get install --yes fuse; \
	fi

post-install: system-icons chsh

system-icons:
	garcon-helper copy-icons

chsh:
# I won't run chsh inside Makefile until I find out a proper way to do this
# 	scripts/chsh-zsh

all: init chemacs home-manager lorri

init: install-hooks init-home-manager

init-home-manager: update-nix-channels
	nix-shell -p bash --command 'bash choose-profile.bash'
	if nix-env -q 'git.*' >/dev/null 2>&1; then \
		echo "Uninstalling git to avoid conflict..."; \
		nix-env -e git; \
	fi
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install

update-nix-channels:
	nix-channel --update

chemacs:
	cd contrib/chemacs && ./install.sh

	if [ ! -f "$(HOME)/.emacs-profiles.el" ]; then \
		install -m 644 -t "$(HOME)" -v dotfiles/.emacs-profiles.el; \
	fi

	if [ ! -f "$(HOME)/.custom.el" ]; then \
		touch "$(HOME)/.custom.el"; \
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
		chsh update-nix-channels init-home-manager lorri tangle
