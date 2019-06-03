x:
{
  # You have to configure an identity
  identity = x.identity or import ../identity.nix;
  github = { user = "akirak"; } // (x.github or {});
  language = {
    base = "en";
  } // (x.language or {});
  locale = {
    # Default locale
    LANG = "en_GB.UTF-8";
    # Fallback locales
    LANGUAGE = "en_US:zh_CN:zh_TW:ja:en";
    LC_ALL = "C";
    # Use ISO 8601 (YYYY-MM-DD) date format
    LC_TIME = "en_DK.UTF-8";
  } // (x.locale or {});
  preferences = {
    useBrowserPass = true;
    addGlobalGitIdentity = false;
  } // (x.preferences or {});
  platform =
  let
    that = x.platform;
  in rec {
    isWsl = that.isWsl or false;
    isChromeOS = that.isChromeOS or false;
    isNixOS = that.isNixOS or false;
    isWayland = that.isWayland or isChromeOS;
  };
}
