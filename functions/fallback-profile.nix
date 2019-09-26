x:
{
  # You have to configure an identity
  identity = x.identity or import ../identity.nix;
  github = { user = "akirak"; } // (x.github or {});
  language = {
    base = "en";
  } // (x.language or {});
  # This doesn't seem to take effect, so I will set locales directly
  # in sessionVariables.
  locale = x.locale or {};
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
