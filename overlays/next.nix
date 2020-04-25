self: super:
let
  # TODO: Globally use a pinned version in from master branch
  nixos-unstable = (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  })) {};
in
{
  next = nixos-unstable.next;
}
