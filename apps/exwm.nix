{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    xorg.xorgserver
    xorg.xdpyinfo
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
      exec = "${binDir}/hm-session emacs --exwm";
      tryExec = "${binDir}/emacs";
      startupWmClass = "Emacs";
      icon = "xorg";
    };

  home.file.".local/share/applications/exwm-xephyr.desktop".text =
    desktop.mkApplicationEntry {
      name = "EXWM on Xephyr";
      exec = "systemctl --user start exwm.service";
      tryExec = "${binDir}/Xephyr";
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
        Type = "simple";

        ExecStart = "${binDir}/xephyr-launcher :2";

        Environment = [
          "DISPLAY=:0"
          "PATH=${binDir}:/usr/bin:/bin"
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
