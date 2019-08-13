{ profile, pkgs, lib, desktop, ... }:
with profile.path;
let
  nixGLCommand = "nixGLIntel";
in
{
  home.packages = with pkgs; [
    alacritty
    alacritty-icons
  ];

  home.file.".local/share/applications/alacritty.desktop".text =
    desktop.mkApplicationEntry {
      name = "Alacritty";
      keywords = "shell;prompt;command;commandline;cmd;";
      comment = "GPU-enabled terminal emulator";
      exec = "${hmSessionBin} ${nixGLCommand} alacritty";
      tryExec = "${binDir}/alacritty";
      startupNotify = true;
      startupWmClass = "Alacritty";
      categories = "System;TerminalEmulator;";
      icon = "alacritty-term";
      dBusActivatable = true;
    };
}
