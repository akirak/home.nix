{ profile, pkgs, lib, ... }:
{
    # dunst = {};
    # flameshot = {};
    # gpg-agent = {};

    keybase = {
      enable = true;
    };

    # mbsync = {};
    # Run syncthing service. This is triggered by default.target
    syncthing = {
      enable = true;
      tray = false;
    };
    # udiskie = {};

    # Only on NixOS
    # random-background = {};
}
