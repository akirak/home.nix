{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    # Make Nix flakes available
    (import ./nix/flakes.nix { inherit pkgs; })
  ];
}
