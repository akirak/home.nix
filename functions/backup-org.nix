{ lib, profile, ... }: { name, repo, interval }:
{
  systemd.user.timers."backup-org@${name}" = {
    Unit = {
      Description = "Backup the repository periodically";
    };
    Timer = {
      OnStartupSec = "3min";
      OnUnitActiveSec = interval;
    };
    Install = {
      WantedBy = [
        "default.target"
      ];
    };
  };
  systemd.user.services."backup-org@${name}" =
    with profile.path;
    {
      Unit = {
        Description = "Backup the contents in ${repo} to the Git repository inside itself";
        AssertPathIsDirectory = "${repo}/.git";
      };
      Service = {
        Type = "simple";
        WorkingDirectory = repo;
        ExecStart = "${binDir}/backup-org-git";
      };
  };
}
