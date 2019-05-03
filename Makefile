export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

all: init chemacs home-manager

init: install-hooks update-nix-channels init-home-manager

update-nix-channels:
	nix-channel --update

init-home-manager:
	which home-manager >/dev/null 2>&1 || nix-shell '<home-manager>' -A install
	./choose-profile.sh

home-manager: deps
	home-manager -I $(shell pwd) switch
	$(MAKE) system-icons chsh

deps: setup-keybase fuse

fuse:
	if grep --silent -P "ID(_LIKE)?=debian" /etc/os-release \
		&& ! which fusermount >/dev/null 2>&1 \
		&& ! which wsl.exe >dev/null 2>&1 ; then \
		sudo apt-get install --yes fuse; \
	fi

post-install: system-icons chsh

system-icons:
	if [ -n "$(SOMMELIER_VERSION)" ]; then \
		sudo mkdir -p /usr/share/icons/gnome; \
		sudo rsync -ra --copy-links \
			"$(HOME)/.local/share/icons/favorites/" \
			/usr/share/icons/gnome/; \
	fi

install-hooks:
	if [ -e .git ]; then git config core.hooksPath .githooks; fi

chemacs:
	cd contrib/chemacs && ./install.sh

	if [ ! -f "$(HOME)/.emacs-profiles.el" ]; then \
		install -m 644 -t "$(HOME)" -v dotfiles/.emacs-profiles.el; \
	fi

	if [ ! -f "$(HOME)/.custom.el" ]; then \
		touch "$(HOME)/.custom.el"; \
	fi

clean:
	sudo rm -rf /homeless-shelter

chsh:
	scripts/chsh-zsh

setup-keybase:
	[ -e /keybase ] || sudo mkdir /keybase

.PHONY: install-hooks all chemacs home-manager system-icons clean \
	chsh update-nix-channels init-home-manager setup-keybase
