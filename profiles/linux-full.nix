# Full profile intended for testing
{ ... }:
{
  preferences = {
    useBrowserPass = true;
    addGlobalGitIdentity = true;
  };
  platform = rec {
    isChromeOS = false;
    isNixOS = false;
    isWayland = false;
  };
}
