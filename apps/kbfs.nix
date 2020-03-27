{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    keybase
    keybase-gui
  ];

  home.file.".local/share/applications/keybase.desktop".text =
    desktop.mkApplicationEntry {
      name = "Keybase";
      exec = "/usr/bin/env PATH=${binDir}:/usr/bin:/bin ${binDir}/keybase-gui";
      tryExec = "${binDir}/keybase-gui";
      icon = "keybase";
      startupWmClass = "Keybase";
    };

  services.keybase = {
    enable = true;
  };

  services.kbfs = {
    enable = true;
  };

  systemd.user.services.kbfs-root =
    {
      Unit = {
        Description = "Preferred mount point (/keybase) for Keybase File System";
      };

      Service = {
        Type = "oneshot";
        ExecStart ="/bin/sh -c '[ -e /keybase ] || sudo ${pkgs.coreutils}/bin/ln -sf $HOME/keybase /keybase'";
      };

      Install = {
        WantedBy = [ "kbfs.service" ];
      };
    };

}
