self: super:
let
  nixos-unstable = (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  })) {};
in
{
  next = nixos-unstable.next;
}
