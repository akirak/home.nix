attrs@{ profile, lib, ... }:
with lib;
with profile.preferences;
[
  (import ./emacs.nix attrs)
  (import ./zsh.nix attrs)
  (import ./graphical.nix attrs)
  # (optionalAttrs (!profile.platform.isWsl) (import ./tilix.nix attrs))
  (import ./alacritty.nix attrs)
  (optionalAttrs profile.platform.isChromeOS (import ./garcon.nix attrs))
  (optionalAttrs profile.platform.isWayland (import ./wayland.nix attrs))
  # (import ./lorri.nix attrs)
  # (import ./kbfs.nix attrs)
  (import ./exwm.nix attrs)
  # (import ./polar.nix attrs)
  # (import ./calibre.nix attrs)
  # (import ./myrepos.nix attrs)
  (import ./haskell.nix attrs)
  # (import ./next.nix attrs)
  # (import ./qutebrowser.nix attrs)
  # (import ./recoll.nix attrs)
]
