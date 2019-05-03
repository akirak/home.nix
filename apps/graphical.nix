# Graphical desktop integration
{ profile, pkgs, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    notify-desktop
  ];

  # Like above, add all icons in ~/.nix-profile/share/icons to
  # ~/.local/share/icons. This is unnecessary if I could set
  # XDG_DATA_DIRS as read by Garcon.
  home.file.".local/share/icons/favorites" = {
    source = "${homeDirectory}/.nix-profile/share/icons/favorites";
  };

  systemd.user.services = {
    "notify-failure@" = {
      Unit = {
        Description = "Notify failure of a service";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${binDir}/notify-desktop '%i service has exited.'";
      };
    };
  };
}
