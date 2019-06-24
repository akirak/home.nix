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
]
