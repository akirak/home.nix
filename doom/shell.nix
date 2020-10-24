with (import ../nix/pkgs.nix);
with builtins;
let
  configDir = "${builtins.getEnv "HOME"}/.config/doom-runner";
in
mkShell {
  XDG_CONFIG_HOME = configDir;

  DOOMDIR = toString ./.;

  buildInputs = [
    emacs
  ];

  shellHook = ''
    if [[ -f "$HOME/.emacs" || -d "$HOME/.emacs.d" ]]; then
      echo "Non-XDG user-emacs-directory is getting in the way."
      exit 1
    fi

    configDir="''${XDG_CONFIG_HOME}"
    doomDir="$configDir/emacs"
    privateDir="$DOOMDIR"

    mkdir -p $configDir
    if ! [[ -d $doomDir ]]; then
      git clone --depth 1 https://github.com/hlissner/doom-emacs $doomDir
    fi

    export PATH="$doomDir/bin:$PATH"

    if ! [[ -d "$privateDir" ]]; then
      echo
      echo "The installation of Doom has not been completed yet."
      echo
      echo "If you have your own private config, clone it to $privateDir."
      echo
      echo "Run 'doom install' before you start Emacs for the first time."
      echo
    fi
  '';
}
