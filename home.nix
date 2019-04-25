{ pkgs, ... }:

{
  programs = {
    emacs = {
      enable = true;
    };
  };

  # home.file = {
  # };

  programs.home-manager = {
    enable = true;
    path = "~/.nix-defexpr/channels/home-manager";
  };
}
