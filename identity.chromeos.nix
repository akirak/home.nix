# Host-specific configuration should go into this file.
{ ... }:
{
  hostname = "penguin";
  username = "akirakomamura";
  fullname = "Akira Komamura";
  email = "akira.komamura@gmail.com";
  github = {
    user = "akirak";
  };
  language = {
    base = "en";
    address = "ja";
  };
  locale = rec {
    # Default locale
    LANG = "en_GB.UTF-8";
    # Fallback locales
    LANGUAGE = "en_US:en";
    # Use ISO 8601 (YYYY-MM-DD) date format
    LC_TIME = "en_DK.UTF-8";
    # NOTE: This might be deprecated
    LC_COLLATE = "C";
  };
  preferences = {
    useBrowserPass = true;
    addGlobalGitIdentity = true;
  };
  platform = rec {
    isChromeOS = true;
    isNixOS = false;
    # I will use Wayland only on Chrome OS (which enforces Wayland)
    # for now
    isWayland = isChromeOS;
  };
}
