{ profile, pkgs, lib, ... }:
{
    # dunst = {};
    # flameshot = {};

  gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    defaultCacheTtlSsh = 60;
    extraConfig = ''
allow-emacs-pinentry
allow-loopback-pinentry
'';
    # pinentryFlavor = "gtk2";
    sshKeys = [
      "5B3390B01C01D3EE"
    ];
  };

    # mbsync = {};
    # udiskie = {};

    # Only on NixOS
    # random-background = {};
}
