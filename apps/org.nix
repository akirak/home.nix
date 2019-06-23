{ profile, pkgs, lib, ... }:
{
  # Run syncthing service. This is triggered by default.target
  services.syncthing = {
    enable = true;
    tray = false;
  };

  systemd.user.timers."backup-org@notes" = {
    Unit = {
      Description = "Backup the repository periodically";
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
  systemd.user.services."backup-org@notes" =
    with profile.path;
    let repo = "%h/lib/notes";
    in {
      Unit = {
      Description = "Backup contents in ~/lib/notes to the Git repository inside itself";
        AssertPathIsDirectory = "${repo}/.git";
      };
      Service = {
        Type = "simple";
        WorkingDirectory = repo;
        ExecStart = "${binDir}/backup-org-git";
    };
  };
}
