install-hooks:
	cp -fv -t .git/hooks meta/pre-push
	chmod +x .git/hooks/pre-push

uninstall-hooks:
	rm -v .git/hooks/pre-push

.PRUNE: install-hooks uninstall-hooks
