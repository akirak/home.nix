export HOME_MANAGER_CONFIG = $(shell pwd)/home.nix

all:
	home-manager -I $(shell pwd) switch

install-hooks:
	if [ -d .git ]; then git config --add core.hooksPath .githooks; fi

.PRUNE: install-hooks all
