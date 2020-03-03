{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    calibre
    html2text
    # gitAndTools.git-annex
    # gitAndTools.git-annex-remote-rclone
    rclone
  ];
}
