{ profile, path }:
let
  profileWithFallback = import ./fallback-profile.nix profile;
in
{
  # TODO: Add validation using assert

  inherit (profileWithFallback) identity github language locale preferences platform;

  inherit path;
}
