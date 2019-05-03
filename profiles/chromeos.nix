# Host-specific configuration should go into this file.
{ ... }:
{
  identity = {
    fullname = "Akira Komamura";
    email = "akira.komamura@gmail.com";
  };
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
