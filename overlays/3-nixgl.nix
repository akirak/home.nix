self: super:
{
  nixGL = import (import ../nix/sources.nix).nixGL {
    pkgs = super;
  };
}
