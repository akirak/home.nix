{ profile, pkgs, lib, ... }:
{
  # Run syncthing service. This is triggered by default.target
  services.syncthing = {
    enable = true;
    tray = false;
  };

  systemd.user.timers.backup-org = {
    Unit = {
      Description = "Run backup-org.service periodically";
    };
    Timer = {
      OnUnitActiveSec = "5m";
    };
    Install = {
      WantedBy = [
        "default.target"
      ];
    };
  };
  systemd.user.services.backup-org =
    with profile.path;
    let repo = "%h/org";
    in {
      Unit = {
        Description = "Backup contents in ~/org to the Git repository inside itself";
        AssertPathIsDirectory = "${repo}/.git";
      };
      Service = {
        Type = "simple";
        WorkingDirectory = repo;
        ExecStart = "${binDir}/backup-org-git";
      };
    };
}
