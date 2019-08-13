#!/bin/sh
NIX_OS_VERSION=unstable
HM_URL=https://github.com/rycee/home-manager/archive/master.tar.gz
REPO_URL=https://github.com/akirak/home.nix.git
REPO_DEST="$HOME/home.nix"

set -e

export NIX_BUILD_SHELL=$(command -v bash)

if ! command -v nix-env >/dev/null 2>&1; then
    curl https://nixos.org/nix/install | sh \
        && . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

nix-channel --add https://nixos.org/channels/nixos-${NIX_OS_VERSION} nixpkgs
nix-channel --add "${HM_URL}" home-manager
nix-channel --update

if ! command -v git >/dev/null 2>&1; then
    nix-env -i git
fi

if ! command -v systemctl >/dev/null 2>&1; then
    echo "Installing systemd from nixpkgs."
    echo "This may not work on non-NixOS distribution."
    nix-env -i systemd
fi

if [ ! -d /etc/nixos ]; then
    mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
fi

if [ "$PWD" = "${REPO_DEST}" ]; then
    origin="$(git config --local remote.origin.url)"
    # Ensure that the origin is the same as REPO_URL
    [ "$origin" = "${REPO_URL}" ]
else
    if [ ! -d "${REPO_DEST}" ]; then
        git clone "${REPO_URL}" "${REPO_DEST}"
    fi
    cd "${REPO_DEST}"
fi
git submodule update --init --recursive

if nix-env -q 'git.*' >/dev/null 2>&1; then
    echo "Uninstalling git to avoid conflict..."
    nix-env -e git
fi

echo <<EOF
Choose a profile and run

  make all

EOF

if [ -z "${BOOTSTRAP_PREVENT_SUBSHELL}" ]; then
    nix-shell -p gnumake git
fi
