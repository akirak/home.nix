export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

all: chemacs
	home-manager -I $(shell pwd) switch

install-hooks:
	if [ -d .git ]; then git config --add core.hooksPath .githooks; fi

chemacs:
	cd contrib/chemacs && ./install.sh

.PRUNE: install-hooks all chemacs
