install-hooks:
	if [ -d .git ]; then git config --add core.hooksPath .githooks; fi

.PRUNE: install-hooks
