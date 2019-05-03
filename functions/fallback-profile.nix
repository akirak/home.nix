x:
{
  # You have to configure an identity
  identity = if x ? identity then x.identity else import ../identity.nix;
  github = if x ? github then x.github else {
    user = "akirak";
  };
  language = if x ? language then x else {
    base = "en";
    address = "ja";
  };
  locale =
  let
    fallback = rec {
      # Default locale
      LANG = "en_GB.UTF-8";
      # Fallback locales
      LANGUAGE = "en_US:en";
      # Use ISO 8601 (YYYY-MM-DD) date format
      LC_TIME = "en_DK.UTF-8";
      # NOTE: This might be deprecated
      LC_COLLATE = "C";
    };
    that = x.locale;
  in if x ? locale
  then
  {
    # Default locale
    LANG = if that ? LANG then that.LANG else fallback.LANG;
    # Fallback locales
    LANGUAGE = if that ? LANGUAGE then that.LANGUAGE else fallback.LANGUAGE;
    # Use ISO 8601 (YYYY-MM-DD) date format
    LC_TIME = if that ? LC_TIME then that.LC_TIME else fallback.LC_TIME;
    # NOTE: This might be deprecated
    LC_COLLATE = if that ? LC_COLLATE then that.LC_COLLATE else fallback.LC_COLLATE;
  }
  else fallback;
  preferences =
  let
    defaults = {
      useBrowserPass = true;
      addGlobalGitIdentity = false;
    };
    that = x.preferences;
  in if x ? preferences
  then rec {
    useBrowserPass =
    if that ? useBrowserPass
      then that.useBrowserPass
      else defaults.useBrowserPass;
    addGlobalGitIdentity =
    if that ? addGlobalGitIdentity
    then that.addGlobalGitIdentity
    else defaults.addGlobalGitIdentity;
  } else defaults;
  platform =
  let
    that = x.platform;
  in rec {
    isChromeOS = if that ? isChromeOS then that.isChromeOS else false;
    isNixOS = if that ? isNixOS then that.isNixOS else false;
    isWayland =
    if that ? isWayland
      then that.isWayland
      else isChromeOS;
  };
}
