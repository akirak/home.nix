{ pkgs, lib, ... }:
with lib;
let
  profile = import ./functions/profile.nix {
    profile = import ./profile.nix {};
    path =
      let
        homeDirectory = builtins.getEnv "HOME";
        channelsDir = "${homeDirectory}/.nix-defexpr/channels";
        binDir = "${homeDirectory}/.nix-profile/bin";
        hmSessionBin = "${binDir}/hm-session";
      in
      {
        inherit homeDirectory channelsDir binDir hmSessionBin;
      };
  };
  extendConfigWith = import ./functions/extend-config.nix { inherit lib; };
  desktop = import ./functions/desktop.nix;
  attrs = { inherit profile pkgs lib desktop; };
in
extendConfigWith (import ./base attrs) (import ./apps attrs)
