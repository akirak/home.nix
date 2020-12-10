{ pkgs, lib, ... }:
with builtins;
with lib;
let
  profile =
    let
      identity = import ~/local/identity.nix;
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
          addGlobalGitIdentity = identity.globalGitIdentity or false;
        } // (x.preferences or {});
        platform =
          let
            hasEnv = name: getEnv name != "";
            osRelease = readFile "/etc/os-release";
            osLines = filter isString (split "\n" osRelease);
            getOsField = key:
              head (filter (x: x != null) (map (match key) osLines));
            osName = getOsField "NAME=(.+)";
            osId = getOsField "ID=(.+)";
          in rec {
            # TODO: Detect Windows Subsystem for Linux
            isWsl = false;
            isChromeOS = hasEnv "SOMMELIER_VERSION";
            isNixOS = osId == "nixos";
            isWayland = isChromeOS || hasEnv "WAYLAND_DISPLAY";
          };
      };
    in
      (mkProfile identity) //
    {
      inherit identity;

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
