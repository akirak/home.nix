export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

all: install-hooks chemacs home-manager system-icons

home-manager:
	home-manager -I $(shell pwd) switch

system-icons:
	if [ -n "$(SOMMELIER_VERSION)" ]; then \
		sudo mkdir -p /usr/share/icons/gnome; \
		sudo rsync -ra --copy-links \
			"$(HOME)/.local/share/icons/favorites/" \
			/usr/share/icons/gnome/; \
	fi

install-hooks:
	if [ -d .git ]; then git config core.hooksPath .githooks; fi

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

.PRUNE: install-hooks all chemacs home-manager system-icons clean
