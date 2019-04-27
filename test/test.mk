all: chemacs

circleci:
	echo "No tests are performed for now."

chemacs:
	test -f $(HOME)/.emacs

.PRUNE: all circleci chemacs
