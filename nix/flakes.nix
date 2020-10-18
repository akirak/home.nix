{ pkgs ? import <nixpkgs> {} }:
pkgs.symlinkJoin {
  name = "nix";
  paths = [ pkgs.nixFlakes ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nix --add-flags \
      '--option experimental-features "nix-command flakes ca-references"'
  '';
}
