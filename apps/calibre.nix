{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    calibre
    gitAndTools.git-annex
    gitAndTools.git-annex-remote-rclone
    rclone
  ];
}
