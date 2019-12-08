{ profile, pkgs, lib, desktop, ... }:
# Based on
# https://github.com/Gerschtli/home-manager-configurations/blob/b4390e68d50852f8006968d0fe57f07b3786b815/modules/config/development/lorri.nix
with profile.path;
{
  home.packages = with pkgs; [
    lorri
  ];

  systemd.user = {
    services.lorri = {
      Unit = {
        Description = "lorri build daemon";
        Documentation = "https://github.com/target/lorri";
        ConditionUser = "!@system";
        Requires = "lorri.socket";
        After = "lorri.socket";
        RefuseManualStart = true;
      };

      Service =
        let
          path = with pkgs; lib.makeSearchPath "bin" [ nix gnutar git mercurial ];
        in
          {
            # TODO: Set it to {pkgs.lorri}/bin/lorri
            # You need a package named lorri
            ExecStart = "${binDir}/lorri daemon";
            PrivateTmp = true;
            ProtectSystem = "strict";
            WorkingDirectory = "%h";
            Restart = "on-failure";
            Environment = [
              "RUST_BACKTRACE=1"
              "PATH=${path}"
            ];
          };
    };

    sockets.lorri = {
      Unit = {
        Description = "lorri build daemon";
      };

      Socket = {
        ListenStream = "%t/lorri/daemon.socket";
      };

      Install = {
        WantedBy = [
          "sockets.target"
          "default.target"
        ];
      };
    };
  };
}
