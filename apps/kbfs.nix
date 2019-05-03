{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    kbfs
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

  # An alternative service unit for kbfs.
  #
  # To use this service, you have to take the following additional steps:
  #
  # 1. Install a package that provides =fusermout=. On Debian,
  # this is fuse package. Note that fusermount 2.9.9 from nixpkgs
  # doesn't seem to work, while fusermount 2.9.7 from the Debian
  # repo works.
  #
  # 2. Create /keybase directory owned by the user.
  systemd.user.services.kbfs =
    let
      mountPoint = "/keybase";
    in
    {
      Unit = {
        Description = "Keybase File System";
        Requires = [ "keybase.service" ];
        After = [ "keybase.service" ];
        AssertPathIsDirectory = mountPoint;
        # Use fusermount provided by the OS distribution
        AssertFileIsExecutable = "/bin/fusermount";
      };

      Service = {
        Environment = [
          "KEYBASE_SYSTEMD=1"
        ];
        ExecStart ="${pkgs.kbfs}/bin/kbfsfuse ${mountPoint}";
        # Use fusermount provided by the OS distribution
        ExecStopPost = "/bin/fusermount -u ${mountPoint}";
        Restart = "on-failure";
        PrivateTmp = true;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

}
