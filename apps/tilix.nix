{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    tilix
    suru-plus-terminal-icons
  ];

  home.file.".local/share/applications/com.gexperts.Tilix.desktop".text =
    desktop.mkApplicationEntry {
      name = "Tilix";
      keywords = "shell;prompt;command;commandline;cmd;";
      comment = "A tiling terminal for Gnome";
      exec = "${hmSessionBin} tilix";
      tryExec = "${binDir}/tilix";
      startupNotify = true;
      startupWmClass = "Tilix";
      categories = "System;TerminalEmulator;X-GNOME-Utilities;";
      icon = "terminal";
      dBusActivatable = true;
      actions = {
        new-window = {
          name = "New Window";
          exec = "${hmSessionBin} tilix --action=app-new-window";
        };
        new-session = {
          exec = "${hmSessionBin} tilix --action=app-new-session";
          name = "New Session";
        };
        preferences = {
          exec = "${hmSessionBin} tilix --preferences";
          name = "Preferences";
        };
      };
    };
}
