#!/usr/bin/env bash

set -euo pipefail

# Nixpkgs channel url to subscribe
NIXPKGS=https://nixos.org/channels/nixpkgs-unstable

# Set the build shell to bash, not /bin/sh
export NIX_BUILD_SHELL="$(command -v bash)"

#############
# Utilities #
#############

has_executable() { command -v "$1" >/dev/null; }

err() { echo "$*" >&2; }

is_wsl_1() {
  if grep -F Linux /proc/sys/kernel/ostype >/dev/null; then
    return 1
  fi
  grep -P "(Microsoft|WSL)" /proc/sys/kernel/osrelease > /dev/null \
    && grep -P "(Microsoft|WSL)" /proc/version >/dev/null
}

is_like_debian() {
  grep -P ^'ID(_LIKE)?=debian' /etc/os-release >/dev/null
}

is_nixos() {
  [ -d /etc/nixos ]
}

#########
# Tasks #
#########

create_initial_nix_conf() {
  if is_wsl_1; then
    echo <<EOF > $HOME/.config/nix/nix.conf
sandbox = false
use-sql-wal = false
EOF
  fi
}

install_dependencies() {
  if ! has_executable xz; then
    if is_like_debian; then
      sudo apt-get update --yes
      sudo apt-get install --yes xz-utils
    else
      err "xz program is missing, but don't know how to install it"
      exit 1
    fi
  fi
}

setup_channels() {
  nix-channel --add "$NIXPKGS" nixpkgs
  nix-channel --update
}

nix_install_systemd() {
    echo "Installing systemd from nixpkgs."
    echo "This may not work on non-NixOS distribution."
    nix-env -i systemd
}

########
# Main #
########

# Skip the following steps if run interactively
case $- in
  *i*)
    return
    ;;
  *)
    ;;
esac

if ! [ -f "$$HOME/.config/nix/nix.conf" ]; then
  create_initial_nix_conf
fi

if ! has_executable nix-env; then
  # Install programs needed to run the Nix installer, e.g. xz
  install_dependencies

  # multi-user installation
  sh "<(curl -L https://nixos.org/nix/install)" --daemon

  # Alternatively, you single-user installation
  # sh <(curl -L https://nixos.org/nix/install) --no-daemon

  # Because NixOS has nix-env by default, this will never be run on the platform
  mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER

  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

setup_channels

# This is unnecessary un recent versions of Debian/Ubuntu
if ! has_executable systemctl; then
  nix_install_systemd
fi

# Enter a subshell where Nix is available
exec "$SHELL"
