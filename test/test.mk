all: chemacs

chemacs:
	test -f $(HOME)/.emacs

.PRUNE: all chemacs
