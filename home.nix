{ pkgs, lib, ... }:
with lib;
let
  profile =
    let
      mkProfile = x: rec {
        # You have to configure an identity
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
      };
    in
      (mkProfile (import ./profile.nix {})) //
    {
      identity = import ~/local/identity.nix;

      path =
        rec {
          homeDirectory = builtins.getEnv "HOME";
          channelsDir = "${homeDirectory}/.nix-defexpr/channels";
          binDir = "${homeDirectory}/.nix-profile/bin";
          nixBinDir =
            if profile.platform.isNixOS
            then "/run/current-system/sw/bin"
            else binDir;
        };
    };
  extendConfigWith = import ./functions/extend-config.nix { inherit lib; };
  desktop = import ./functions/desktop.nix;
  attrs = { inherit profile pkgs lib desktop; };
in
extendConfigWith (import ./base attrs) (import ./apps attrs)
