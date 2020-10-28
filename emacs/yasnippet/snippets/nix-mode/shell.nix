# -*- mode: snippet -*-
# name: Minimal shell.nix (1)
# key: mkShell
# --
let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = [
     ${1:pkgs.hugo}
  ];
}