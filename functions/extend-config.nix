{ lib }: base: extensions:
with lib;
foldl' (import ./merge.nix { inherit lib; }) base extensions
