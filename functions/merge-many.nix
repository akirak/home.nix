# See also ./extend-config.nix
{ lib }: configs:
with lib;
foldl' (import ./merge.nix { inherit lib; }) {} configs
