{ pkgs, ... }:

{
  programs.home-manager = {
    enable = true;
    path = "~/.nix-defexpr/channels/home-manager";
  };
}
