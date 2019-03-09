install-hooks:
	cp -fv test/test-local.sh .git/hooks/pre-push
	chmod +x .git/hooks/pre-push

uninstall-hooks:
	rm -v .git/hooks/pre-push

.PRUNE: install-hooks uninstall-hooks
