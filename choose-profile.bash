#!/bin/bash

# Automatically choose a profile for the current environment

has_executable() { which "$1" 2>&1 >/dev/null; }

if has_executable tput; then
    bold=$(tput bold)
    red=$(tput setaf 1)
    blue=$(tput setaf 4)
    reset=$(tput sgr0)
else
    bold=""
    red=""
    blue=""
    reset=""
fi

error() { echo $red"$*"$reset >&2; }

heading() { echo; echo $bold$blue"$*"$reset; }

if [ -e profile.nix ]; then
    echo "A profile is already set."
    stat profile.nix
    exit
fi

if [ "$1" = "--yes" ] || [ "${HOME_NIX_PROFILE_NOCONFIRM}" = "1" ]; then
    always_yes=1
fi

ask_yes_no() {
    local answer
    if [ "${always_yes}" = 1 ]; then
        echo y
    else
        read -n1 answer
        echo $answer
    fi
}

set_profile_file() { ln -sv "$1" profile.nix; }

set_profile() {
    local target="$1" title="$2"
    echo "A profile for $title is being chosen."
    echo -n "Use it? (y/n): "
    case $(ask_yes_no) in
        Y|y)
            echo
            set_profile_file profiles/$target
            return
            ;;
        *)
            echo
            heading "Manual Creation of a Profile"
            echo "Please create profile.nix."
            echo "You probably can create on by symlinking to a file in profiles directory."
            echo "Entering a shell."
            "$SHELL"
            if [ ! -e profile.nix ]; then
                error "The profile was not created."
                echo "Aborting"
                exit 1
            fi
            ;;
    esac
}

heading "Choose a Profile Based on the Host Name"

hostname="$(hostname -s)"
if [ -e "profiles/${hostname}.nix" ]; then
    echo "${hostname}.nix is chosen based on the host name."
    set_profile_file "profiles/${hostname}.nix"
    exit 0
else
    echo "There is no profile matching the host name '${hostname}'."
fi

is_chromeos() { [ -n "${SOMMELIER_VERSION}" ]; }
is_wsl() { ./scripts/is-wsl; }

is_supported_linux() {
    echo "Checking if the platform is Linux..."
    uname -a

    if [ "$(uname --operating-system)" = GNU/Linux ]; then
        echo "The operating system is GNU/Linux."
    else
        error "The operating system is not GNU/Linux."
        return 1
    fi

    if [ -e /etc/os-release ]; then
        echo "/etc/os-release exists."
    else
        error "/etc/os-release does not exist."
        return 1
    fi

    . /etc/os-release

    if [ "$ID" = debian ]; then
        echo "The operating system is Debian."
    elif [ "${ID_LIKE}" = *debian* ]; then
        echo "The operating system is like Debian: $ID"
    elif [ "$ID" = nixos ]; then
        echo "The operating system is NixOS."
        return
    else
        echo "The operaing system may not be supported by this config: $ID"
        echo "Continueing anyway"
    fi

    if which systemctl; then
        echo "systemctl exists."
    else
        error "systemctl does not exist."
        return 1
    fi
}

# Choose a profile based on the environment
heading "Choose the Default Profile for the Operating System"

# Chrome OS
if is_chromeos; then
    set_profile chromeos.nix "Chrome OS"
# Windows Subsystem for Linux
elif is_wsl; then
    # TODO: Create wsl.nix profile
    set_profile wsl.nix "WSL"
# Other Linux
elif is_supported_linux; then
     set_profile linux-basic.nix "Linux"
else
    error "Failed to determine the OS distribution."
    exit 1
fi
