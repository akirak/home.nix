{ pkgs, profile, ... }:
{
  home.packages = with pkgs; [ recoll ];

  # Periodically index files on the local file system using recoll.
  # For details see https://lesbonscomptes.com/recoll/usermanual/webhelp/docs/RCL.INDEXING.PERIODIC.html
  systemd.user = {
    services.recoll = {
      Unit = {
        Description = "Index local files using recoll-index";
      };
      Service = {
        Type = "simple";
        ExecStart = "${profile.path.binDir}/recoll";
      };
    };

    timers.recoll = {
      Unit = {
        Description = "Run recoll-index periodically";
      };
      Timer = {
        OnStartupSec = "1h";
        OnUnitActiveSec = "interval";
      };
      Install = {
        WantedBy = [
          "default.target"
        ];
      };
    };
  };
}
