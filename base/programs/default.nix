attrs@{ profile, pkgs, lib, ... }:
with profile;
{

    home-manager = {
      enable = true;
      path = "~/.nix-defexpr/channels/home-manager";
    };

    git = import ./git.nix attrs;

    ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "10m";
    };

    browserpass = {
      enable = false;
      browsers = ["chrome" "chromium"];
    };

    # Web browsers needs regular security patches.
    # Don't install a browser using Nix.
    # Install it as a separate package.
    chromium = {
      enable = false;
    };

    command-not-found = {
      # Use nix-index.
      # enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = ''
        # https://medium.com/analytics-vidhya/best-practice-for-using-poetry-608ab6feaaf
        layout_poetry() {
          if [[ ! -f pyproject.toml ]]; then
            log_status 'No pyproject.toml found. Will initialize poetry in no-interactive mode'
            poetry init -n -q
            poetry run pip install -U pip wheel setuptools
          fi
          poetry run echo >> /dev/null
          local VENV=$(dirname $(poetry run which python))
          export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
          export POETRY_ACTIVE=1
          PATH_add "$VENV"
          if [ ! -L .venv ]; then
            ln -ns $VIRTUAL_ENV .venv
          fi
        }
      '';
    };

    jq = {
      enable = true;
      # colors =
    };

    man = {
      enable = true;
    };

    go = {
      enable = true;
      goBin = "misc/go/bin";
      # This doesn't seem to take effect now.
      # For now, I will configure the variable in zsh.
      goPath = "misc/go";
    };

    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };

    broot = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };

}
