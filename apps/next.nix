{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    next
  ];

  home.file.".config/next/init.lisp".source = ../dotfiles/.config/next/init.lisp;

  home.file.".local/share/applications/next.desktop".text =
    desktop.mkApplicationEntry {
      name = "Next Browser";
      exec = "next";
      tryExec = "${binDir}/next";
      startupWmClass = "next";
      startupNotify = false;
      categories = "Browser";
      icon = "browser";
      dbusActivatable = true;
    };
}
