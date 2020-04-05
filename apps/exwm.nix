{ profile, pkgs, lib, desktop, ... }:
with profile.path;
let
  nixPath = "nixpkgs=${channelsDir}/nixpkgs";
in
{
  home.packages = with pkgs; [
    la-capitaine-icons
  ];

  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    windowManager.command = "${binDir}/hm-session emacs --exwm";
  };

  home.file.".local/share/applications/exwm.desktop".text =
    desktop.mkApplicationEntry {
      name = "EXWM (Replace WM)";
      exec = "${binDir}/nix-shell -p bash --command '${binDir}/hm-session emacs --exwm'";
      tryExec = "${binDir}/emacs";
      startupWmClass = "Emacs";
      icon = "xorg";
    };

  home.file.".local/share/applications/exwm-xephyr.desktop".text =
    desktop.mkApplicationEntry {
      name = "EXWM on Xephyr";
      exec = "systemctl --user start exwm.service";
      tryExec = "${nixBinDir}/nix-shell";
      startupWmClass = "Xephyr";
      icon = "xorg";
    };

  systemd.user.services = {
    xephyr = {
      Unit = {
        Description = "Nested X server";
        StopWhenUnneeded = true;
      };
      Service = {
        Type = "forking";

        ExecStart = "${nixBinDir}/nix-shell -p bash gnugrep xorg.xdpyinfo xorg.xorgserver --command '${binDir}/xephyr-launcher :2'";

        Environment = [
          "DISPLAY=:0"
          "NIX_PATH=${nixPath}"
        ];
      };
    };

    exwm = {
      Unit = {
        Description = "Emacs Window Manager";
        BindsTo = [
          "xephyr.service"
        ];
        After = [
          "xephyr.service"
        ];
        Wants = [
          "default.target"
        ];
        Conflicts = [
          "emacs.service"
        ];
        OnFailure = [
          "notify-failure@exwm.service"
        ];

      };
      Service = {
        Type = "simple";

        # TODO: Save all buffers in existing Emacs sessions

        ExecStart = "${hmSessionBin} emacs --exwm";

        Environment = [
          "DISPLAY=:2"
          "NIX_PATH=${nixPath}"
          # You should get this value by running `gpgconf --list-dirs agent-ssh-socket`
          "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh"
        ];

      };
    };
  };
}
