{ profile, pkgs, lib, desktop, ... }:
{
  # https://nixos.wiki/wiki/Installing_on_Crostini
  home.file.".config/systemd/user/cros-garcon.service.d/override.conf".text = ''
[Service]
Environment="PATH=%h/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin"
Environment="XDG_DATA_DIRS=%h/.nix-profile/share:%h/.local/share:/usr/local/share:/usr/share"
'';
}
