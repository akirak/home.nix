NIX_OS_VERSION=unstable
HM_URL=https://github.com/rycee/home-manager/archive/master.tar.gz

if [ "${USER_EMACS_DIR}" = "" ]; then
    USER_EMACS_DIR="$HOME/.emacs.d"
fi

if ! command -v nix-env >/dev/null 2>&1; then
    curl https://nixos.org/nix/install | sh \
        && . $HOME/.nix-profile/etc/profile.d/nix.sh || exit 1
fi

nix-channel --add https://nixos.org/channels/nixos-${NIX_OS_VERSION} nixpkgs \
    && nix-channel --update || exit 1

if ! command -v make >/dev/null 2>&1; then
    nix-env -i gnumake
fi

if ! command -v git >/dev/null 2>&1; then
    nix-env -i git
fi

if ! command -v systemctl >/dev/null 2>&1; then
    echo "Installing systemd from nixpkgs."
    echo "This may not work on non-NixOS distribution."
    nix-env -i systemd
fi

mkdir -p "${USER_EMACS_DIR}"
cd "${USER_EMACS_DIR}"
if [ ! -d .git ]; then
    git init
    git remote add origin https://github.com/akirak/emacs.d.git
fi

if [ ! -d /etc/nixos ]; then
    mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
fi

nix-channel --add "${HM_URL}" home-manager || exit 1

echo "Bootstrapping finished."
echo "Enter ~/.emacs.d, fetch and check out a branch, and run make init."
