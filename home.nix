{ pkgs, lib, ... }:
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
in
(import ./base { inherit profile pkgs lib; })
