{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = [
    pkgs.alacritty
  ];

  home.file.".local/share/applications/alacritty.desktop".text =
    desktop.mkApplicationEntry {
      name = "Alacritty (nixGLIntel)";
      keywords = "shell;prompt;command;commandline;cmd;";
      comment = "GPU-enabled terminal emulator";
      exec = "${pkgs.nur.akirak.nixGL.nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty";
      tryExec = "${pkgs.alacritty}/bin/alacritty";
      startupNotify = true;
      startupWmClass = "Alacritty";
      categories = "System;TerminalEmulator;";
      icon = "Alacritty";
      dBusActivatable = true;
    };
}
