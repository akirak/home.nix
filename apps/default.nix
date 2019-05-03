attrs@{ profile, lib, ... }:
with lib;
with profile.preferences;
[
  (import ./emacs.nix attrs)
  (import ./zsh.nix attrs)
  (import ./graphical.nix attrs)
  (import ./tilix.nix attrs)
  (optionalAttrs profile.platform.isWayland (import ./wayland.nix attrs))
  (import ./org-personal.nix attrs)
  (import ./kbfs.nix attrs)
  (import ./exwm.nix attrs)
]
