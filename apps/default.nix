attrs@{ profile, lib, ... }:
with lib;
with profile.preferences;
[
  (import ./emacs.nix attrs)
  (import ./zsh.nix attrs)
  (import ./graphical.nix attrs)
  (optionalAttrs (!profile.platform.isWsl) (import ./tilix.nix attrs))
  (import ./alacritty.nix attrs)
  (optionalAttrs profile.platform.isChromeOS (import ./garcon.nix attrs))
  (optionalAttrs profile.platform.isWayland (import ./wayland.nix attrs))
  (import ./org.nix attrs)
  (import ./kbfs.nix attrs)
  (import ./exwm.nix attrs)
  (import ./myrepos.nix attrs)
  (import ./qutebrowser.nix attrs)
]
