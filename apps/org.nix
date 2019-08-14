{ profile, pkgs, lib, ... }:
let
  merge-many = import ../functions/merge-many.nix { inherit lib; };
  backup-org = import ../functions/backup-org.nix { inherit lib profile; };
in
merge-many
[
  {
    # Run syncthing service. This is triggered by default.target
    services.syncthing = {
      enable = true;
      tray = false;
    };
  }
  # Define backup-org@notes.{service,timer}
  (backup-org
    {
      name = "notes";
      repo = "%h/lib/notes";
      interval = "5m";
    })
  # Define backup-org@journal.{service,timer}
  (backup-org
    {
      name = "journal";
      repo = "%h/lib/journal";
      interval = "30m";
    })
  # Define backup-org@personal-tasks.{service,timer}
  (backup-org
    {
      name = "personal-tasks";
      repo = "%h/lib/tasks.personal";
      interval = "5m";
    })

  {
    systemd.user.timers.build-org = {
      Unit = {
        Description = "Build the Org configuration periodically";
      };
      Timer = {
        OnStartupSec = "1h";
        OnUnitActiveSec = "2h";
      };
      Install = {
        WantedBy = [
          "default.target"
        ];
      };
    };

    systemd.user.services.build-org =
      with profile.path;
      {
        Unit = {
          Description = "Build the Org configuration";
          AssertPathIsDirectory = "${homeDirectory}/lib/notes";
        };
        Service = {
          Type = "simple";
          WorkingDirectory = "${homeDirectory}/lib/notes";
          ExecStart = "${binDir}/make";
        };
      };
  }
]
