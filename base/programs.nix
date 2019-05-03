{ profile, pkgs, lib, ... }:
with profile;
{

    home-manager = {
      enable = true;
      path = "~/.nix-defexpr/channels/home-manager";
    };

    emacs = {
      enable = true;
    };

    git =
    if preferences.addGlobalGitIdentity
    then {
      userName = identity.fullname;
      userEmail = identity.email;
    } else {}
    //
    {
      enable = true;

      aliases = {
        co = "checkout";
        sub = "submodule";
        su = "submodule update --init --recursive";
        l1 = "log --oneline";
      };

      extraConfig = {
        github.user = profile.github.user;

        "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";

      };

      ignores = [];

      # TODO: Define programs.git.signing
      # signing = null;
    };

    ssh = {
      enable = true;
    };

    # TODO: Configure autorandr (possibly unnecessary?)
    # autorandr = {
    #   enable = true;
    # };

    browserpass = {
      enable = preferences.useBrowserPass;
      browsers = ["chrome" "chromium"];
    };

    chromium = {
      enable = true;
    };

    command-not-found = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    jq = {
      enable = true;
      # colors =
    };

    man = {
      enable = true;
    };

    # TODO: Configure mbsync
    # mbsync = {};

    # TODO: Configure msmtp
    # msmtp = {};

    # TODO: Configure obs-studio
    # obs-studio = {};

    # TODO: Configure rofi for Chrome OS, WSL, and NixOS
    # rofi = {};

    skim = {
      # I may or may not try out skim in the future
      enable = true;
      enableZshIntegration = true;
    };

    # I used termite before, but not now. It's a decent term app anyway.
    # termite = {};

    # I am not supposed to use tmux
    tmux = {
      enable = true;
    };

    # vscode = {};

    zsh =
    let
      zDotDir = ".config/zsh";
    in
    {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      dotDir = zDotDir;
      defaultKeymap = "emacs";
      history = {
        expireDuplicatesFirst = true;
        save = 5000;
        share = true;
        size = 5000;
      };
      plugins = [
        {
          name = "zsh-history-substring-search";
          src = pkgs.zsh-history-substring-search;
        }
        {
          name = "pure";
          src = pkgs.zsh-pure-prompt;
        }
        {
          name = "zsh-bd";
          src = pkgs.fetchFromGitHub {
            owner = "Tarrasch";
            repo = "zsh-bd";
            rev = "d4a55e661b4c9ef6ae4568c6abeff48bdf1b1af7";
            sha256 = "020f8nq86g96cps64hwrskppbh2dapfw2m9np1qbs5pgh16z4fcb";
            # date = 2018-07-04T22:33:02+02:00;
          };
        }
        {
          name = "nix-shell";
          src =  pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "b2609ca787803f523a18bb9f53277d0121e30389";
            sha256 = "01w59zzdj12p4ag9yla9ycxx58pg3rah2hnnf3sw4yk95w3hlzi6";
            # date = 2019-04-22T22:00:26+02:00;
          };
        }
      ];
      sessionVariables = {
        "DIRSTACKSIZE" = "20";
        "SPACESHIP_DIR_TRUNC_REPO" = "false";
        "SPACESHIP_DIR_TRUNC" = "0";
        "NIX_BUILD_SHELL" = "zsh";
      };
      initExtra = ''
setopt auto_cd
setopt cdable_vars
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

export SHELL="$0"
'';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "ls" = "ls --color=auto";
        "la" = "ls -a";
        "ll" = "ls -l";
        "rm" = "rm -i";
        "e" = "emacs-server-open";
        "start" = "systemctl --user start";
        "stop" = "systemctl --user stop";
        "enable" = "systemctl --user enable";
        "disable" = "systemctl --user disable";
        "reload" = "systemctl --user daemon-reload";
        "status" = "systemctl --user status";
        "restart" = "systemctl --user restart";
        "list-units" = "systemctl --user list-units";
        "list-unit-files" = "systemctl --user list-unit-files";
        "reset" = "systemctl --user reset-failed";
      };
    };

}
