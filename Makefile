export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

all: install-hooks chemacs home-manager lorri emacs-config

update: home-manager emacs-config

home-manager: tangle deps
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install
	home-manager -I $(shell pwd) switch
	$(MAKE) post-install

tangle:
	if command -v emacs >/dev/null 2>&1; then \
		emacs --batch --eval "(progn (require 'ob) (org-babel-tangle-file \"README.org\"))"; \
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

emacs-config:
	if [ ! -d "$(HOME)/.emacs.d" ]; then \
		git clone -b maint https://github.com/akirak/emacs.d.git "$(HOME)/.emacs.d"; \
	else
		cd "$(HOME)/.emacs.d"; ./update.bash; \
	fi

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
		chsh update-nix-channels init-home-manager lorri tangle emacs-config
