{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    qutebrowser
    qt5.qtwebengine
    nixgl.nixGLIntel
  ];
}
