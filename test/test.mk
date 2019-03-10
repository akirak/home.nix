all: chemacs

chemacs:
	test -f $(HOME)/.emacs
	test -f $(HOME)/.emacs-profiles.el

.PRUNE: all chemacs
