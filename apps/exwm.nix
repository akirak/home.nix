{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    xorg.xorgserver
    xorg.xdpyinfo
    la-capitaine-icons
  ];

  home.file.".local/share/applications/exwm.desktop".text =
    desktop.mkApplicationEntry {
      name = "EXWM";
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
