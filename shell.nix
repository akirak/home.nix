{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  home-manager = import (import ./nix/sources.nix).home-manager {};
in
mkShell {
  buildInputs = [
    home-manager.home-manager

    # Used for development
    shellcheck
  ];
}
