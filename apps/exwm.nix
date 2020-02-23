{ profile, pkgs, lib, desktop, ... }:
with profile.path;
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
      tryExec = "${binDir}/nix-shell";
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

        ExecStart = "${binDir}/nix-shell -p bash gnugrep xorg.xdpyinfo xorg.xorgserver --command '${binDir}/xephyr-launcher :2'";

        Environment = [
          "DISPLAY=:0"
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
        ];

      };
    };
  };
}
