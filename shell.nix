{ pkgs ? import <nixpkgs> {} }:
let
  pre-commit = import ./nix/pre-commit.nix { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = [
    # Make Nix flakes available
    (import ./nix/flakes.nix { inherit pkgs; })
  ];

  shellHook = ''
    ${pre-commit.shellHook}
  '';
}
