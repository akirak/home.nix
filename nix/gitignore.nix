{ pkgs ? import <nixpkgs> {} }:
let
  sources = import ./sources.nix;
in
import sources."gitignore.nix" {
  inherit (pkgs) lib;
}
