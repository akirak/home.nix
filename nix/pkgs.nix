# This file provides a pinned version of nixpkgs with my selected overlays.
#
# You can use 'niv' to update the packages, and you can use cachix to push the
# binary cache.
#
# For example, the following command pushes the unstable version of Emacs to my
# cachix account:
#
#   nix-build pkgs.nix -A emacsUnstable | cachix push akirak
let
  sources = import ./sources.nix;
in
import sources.nixpkgs-unstable {
  overlays = [
    (import sources.emacs-overlay)
  ];
}
