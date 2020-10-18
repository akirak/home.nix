let
  defaultPkgsWithOverlay = import <nixpkgs> {
    overlays = [
      emacs-overlay
    ];

    emacsWithInitDir =
      { name ? "emacs"
      , executableName ? "emacs"
      , pkgs ? defaultPkgsWithOverlay
      , profileRoot ? "${builtins.getEnv "HOME"}/.emacs-eco/profiles/${profileName}"
      , userEmacsDir
      , emacsDrv ? pkgs.emacs
      , executableName ? "emacs"
      }:
        let
          emacsDrv = pkgs.emacsPackagesFor package;
        in
          pkgs.symlinkJoin {
            inherit name;
            paths = [ emacsDrv ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              makeWrapper $out/bin/emacs $out/bin/${executableName} \
                --set XDG_CONFIG_HOME 
            '';
          }
            {
              inherit emacsWithInitDir;
            }
