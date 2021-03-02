attrs@{ profile, lib, ... }:
with lib;
with profile.preferences;
[
  (import ./zsh.nix attrs)
  (import ./graphical.nix attrs)
  (import ./alacritty.nix attrs)
  (optionalAttrs profile.platform.isChromeOS (import ./garcon.nix attrs))
  (optionalAttrs profile.platform.isWayland (import ./wayland.nix attrs))
  # (import ./kbfs.nix attrs)
  (import ./exwm.nix attrs)
  (import ./keychron.nix attrs)
]
