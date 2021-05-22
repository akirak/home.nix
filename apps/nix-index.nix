# This file defines only systemd services for nix-index.
#
# See also the nix-index program module of home-manager.
{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  systemd.user.services.nix-index =
    {
      Unit = {
        Description = "Index Nix packages for search with nix-locate";
      };

      Service = {
        Type = "simple";
        ExecStart ="${pkgs.nix-index}/bin/nix-index";
      };
    };

  systemd.user.timers.nix-index =
    {
      Unit = {
        Description = "Run nix-index service periodically";
      };

      Timer = {
        Persistent = true;
        WakeSystem = false;
        # Run the service once a day
        OnUnitActiveSec = 86400;
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };

}
