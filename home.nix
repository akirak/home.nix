{ pkgs, ... }:

{
  programs = {
    emacs = {
      enable = true;
    };
  };

  home.file = {
    ".emacs".source = ./contrib/chemacs/.emacs;
  };

  programs.home-manager = {
    enable = true;
    path = "~/.nix-defexpr/channels/home-manager";
  };
}
