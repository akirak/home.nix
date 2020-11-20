# Graphical desktop integration
{ profile, pkgs, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    notify-desktop
  ];

  # Prevent GNOME Keyring from auto starting to run my own GPG/ssh
  # agents.
  #
  # https://wiki.archlinux.org/index.php/GNOME/Keyring#Disable_keyring_daemon_components
  #
  # This is necessary for non-NixOS systems.

  home.file.".config/autostart/gnome-keyring-secrets.desktop".text = ''
[Desktop Entry]
Type=Application
Name=Secret Storage Service
Comment=GNOME Keyring: Secret Service
TryExec=/usr/bin/gnome-keyring-daemon
Exec=/usr/bin/gnome-keyring-daemon --start --components=secrets
OnlyShowIn=GNOME;Unity;MATE;
NoDisplay=true
Hidden=true
  '';

  home.file.".config/autostart/gnome-keyring-ssh.desktop".text = ''
[Desktop Entry]
Type=Application
Name=SSH Key Agent
Comment=GNOME Keyring: SSH Agent
TryExec=/usr/bin/gnome-keyring-daemon
Exec=/usr/bin/gnome-keyring-daemon --start --components=ssh
OnlyShowIn=GNOME;Unity;MATE;
Hidden=true
 '';

  # Like above, add all icons in ~/.nix-profile/share/icons to
  # ~/.local/share/icons. This is unnecessary if I could set
  # XDG_DATA_DIRS as read by Garcon.

  # home.file.".local/share/icons/favorites" = {
  #   source = "${homeDirectory}/.nix-profile/share/icons/favorites";
  # };

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
