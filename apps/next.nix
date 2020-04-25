{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    next
  ];

  home.file.".config/next/init.lisp".text =
    ''
(in-package :next)
(add-to-default-list 'vi-normal-mode 'buffer 'default-modes)
    '';

  home.file.".local/share/applications/next.desktop".text =
    desktop.mkApplicationEntry {
      name = "Next Browser";
      exec = "next";
      tryExec = "${binDir}/next";
      icon = "browser";
    };
}
