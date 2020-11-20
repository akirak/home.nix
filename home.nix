{ pkgs, lib, ... }:
with lib;
let
  profile = import ./functions/profile.nix rec {
    profile = import ./profile.nix {};
    path =
      rec {
        homeDirectory = builtins.getEnv "HOME";
        channelsDir = "${homeDirectory}/.nix-defexpr/channels";
        binDir = "${homeDirectory}/.nix-profile/bin";
        nixBinDir =
          if profile.platform.isNixOS
          then "/run/current-system/sw/bin"
          else binDir;
      };
  };
  extendConfigWith = import ./functions/extend-config.nix { inherit lib; };
  desktop = import ./functions/desktop.nix;
  attrs = { inherit profile pkgs lib desktop; };
in
extendConfigWith (import ./base attrs) (import ./apps attrs)
