{ ... }:
{
  config = {
    allowUnfree = true;
    allowBroken = false;
    allowUnsupportedSystem = false;
  };

  overlays =
    let
      path = ../overlays;
      inRepoOverlays = with builtins;
        map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
            (attrNames (readDir path)));
      nurOverlay = self: super:
        {
          nur.akirak =
            import (import ../nix/sources.nix).nur-packages {
              system = builtins.currentSystem;
            };
        };
    in
      inRepoOverlays
      ++
      [
        nurOverlay
      ];
}
