# Host-specific configuration should go into this file.
{ ... }:
{
  preferences = {
    useBrowserPass = true;
    addGlobalGitIdentity = true;
  };
  platform = rec {
    isChromeOS = true;
    isNixOS = false;
    isWayland = isChromeOS;
  };
}
