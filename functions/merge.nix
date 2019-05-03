{ lib, ...}: base: exts:
with lib;
let
  predicate = path: _l: _r:
  init path == ["systemd" "user" "services"] ||
  init path == ["systemd" "user" "targets"] ||
  init path == ["systemd" "user" "timers"] ||
  init path == ["systemd" "user" "sessionVariables"] ||
  init path == ["services"] ||
  init path == ["programs"];
  c1 = lib.recursiveUpdateUntil predicate base exts;
  basePackages = base.home.packages or [];
  newPackages = exts.home.packages or [];
in
c1 // {
  home = c1.home // {
    packages = basePackages ++ newPackages;
    file = (base.home.file or {}) // (exts.home.file or {});
    sessionVariables = (base.home.sessionVariables or {})
    // (exts.home.sessionVariables or {});
  };
}
