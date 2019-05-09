{ profile, pkgs, lib, ... }:
with profile;
{
  home.packages = with pkgs; [
    nix-zsh-completions
    fzy
    powerline-fonts
  ];

  programs.zsh =
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
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
             owner = "b4b4r07";
             repo = "enhancd";
             rev = "a708e6dc1029de310c3b73c2a9d34f33a6e24d14";
             sha256 = "0bxpif2id1kmh48zv96hzgcx3m4qwl0cppaiya868cnlyrb2x9k1";
             # date = 2019-04-01T13:55:23+09:00;
          };
        }
        {
          name = "solarized-man";
          src = pkgs.fetchFromGitHub {
            owner = "zlsun";
            repo = "solarized-man";
            rev = "a902b64696271efee95f37d45589078fdfbbddc5";
            sha256 = "04gm4qm17s49s6h9klbifgilxv8i45sz3rg521dwm599gl3fgmnv";
            # date = ;
            # date = 2017-05-19T00:10:24+08:00;
          };
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "3601297ebfd67f208f489189e984df665ec9242c";
            sha256 = "026ykxgfy0p7y3wcsq0z3kmrs0n67rmxf89kqmiw5vxr9l67jr6l";
            # date = 2019-04-09T15:18:55+02:00;
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
