{ profile, pkgs, lib, ... }:
let backup = { name, repo, interval }:
{
  systemd.user.timers."${name}" = {
    Unit = {
      Description = "Backup the repository periodically";
    };
    Timer = {
      OnUnitActiveSec = interval;
    };
    Install = {
      WantedBy = [
        "default.target"
      ];
    };
  };
  systemd.user.services."${name}" =
    with profile.path;
    {
      Unit = {
      Description = "Backup contents in ${repo} to the Git repository inside itself";
        AssertPathIsDirectory = "${repo}/.git";
      };
      Service = {
        Type = "simple";
        WorkingDirectory = repo;
        ExecStart = "${binDir}/backup-org-git";
    };
  };
};
in
{
  # Run syncthing service. This is triggered by default.target
  services.syncthing = {
    enable = true;
    tray = false;
  };
} //
backup
{
  name = "backup-org@notes";
  repo = "%h/lib/notes";
  interval = "5m";
}
