# Configuration file for nix-desktop
# https://github.com/akirak/nix-desktop
#
# You can install desktop files by running `nix-desktop install .`
let
  pkgs = import <nixpkgs> {};
in
{
  name = "my-config";
  xdg.menu.applications.doom-emacs = {
    Name = "Doom Emacs";
    Icon = "emacs";
    TryExec = "${builtins.getEnv "HOME"}/.config/doom-runner/emacs/bin/doom";
    Exec = "${pkgs.nix}/bin/nix-shell ${builtins.toString ./.}/doom/shell.nix --command emacs";
    StartupWMClass = "Emacs";
  };
}
