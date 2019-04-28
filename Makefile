export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

all: install-hooks chemacs home-manager

home-manager:
	home-manager -I $(shell pwd) switch

install-hooks:
	if [ -d .git ]; then git config core.hooksPath .githooks; fi

chemacs:
	cd contrib/chemacs && ./install.sh

.PRUNE: install-hooks all chemacs home-manager
