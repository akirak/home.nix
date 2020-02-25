{ profile, pkgs, lib, ... }:
with profile;
{
  home.packages = with pkgs; [
    nix-zsh-completions
    fzy
    # You don't need this if you install google-fonts
    # powerline-fonts

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
             rev = "4c6656201e3f70b2e9bc0b29a42fcfeda0109541";
             sha256 = "0dx49rnfz68ij7v5bfjs651mnr63f18zjxzbq1aa68i4q6xp99p3";
             # date = 2019-06-10T22:14:53+09:00;
          };
        }
        {
          name = "solarized-man";
          src = pkgs.fetchFromGitHub {
            owner = "zlsun";
            repo = "solarized-man";
            rev = "e69d2cedc3a51031e660f2c3459b08ab62ef9afa";
            sha256 = "1ljnqxfzhi26jfzm0nm2s9w43y545sj1gmlk6pyd9a8zc0hafdx8";
            # date = ;
            # date = 2019-07-01T11:22:24+08:00;
          };
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "45b6516fad95c8bc35aea44eb7edc8ccbf642007";
            sha256 = "1cf09rls81b00kkbabi562x9kkbwm9p31x9vcbpyz8sixfp5anv3";
            # date = 2019-07-15T07:04:50+02:00;
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
        "VAGRANT_WSL_WINDOWS_ACCESS" = "1";
        # Set locale archives
        # https://github.com/NixOS/nixpkgs/issues/38991
        "LOCALE_ARCHIVE_2_11" = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        "LOCALE_ARCHIVE_2_27" = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        LANG = "en_GB.UTF-8";
        LANGUAGE = "en_US:zh_CN:zh_TW:en";
        LC_ALL = "C";
        LC_CTYPE = "en_GB";
        LC_MESSAGES="en_GB";
        # Use ISO 8601 (YYYY-MM-DD) date format
        LC_TIME = "en_DK.UTF-8";
      };
      initExtra = ''
setopt auto_cd
setopt cdable_vars
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# Support directory tracking on emacs-libvterm.
# https://github.com/akermu/emacs-libvterm#directory-tracking
function chpwd() {
    print -Pn "\e]51;A$(pwd)\e\\";
}

zsh=${profile.path.binDir}/zsh
if [[ -x "$zsh" ]]; then
   export SHELL="$zsh"
fi
'';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "ls" = "ls --color=auto";
        "la" = "ls -a";
        "ll" = "ls -l";
        "rm" = "rm -i";
        "e" = "emacs-server-open";
        "j" = "journalctl -xe";
        "start" = "systemctl --user start";
        "stop" = "systemctl --user stop";
        "enable" = "systemctl --user enable";
        "disable" = "systemctl --user disable";
        "reload" = "systemctl --user daemon-reload";
        "status" = "systemctl --user --full status";
        "restart" = "systemctl --user restart";
        "list-units" = "systemctl --user list-units";
        "list-unit-files" = "systemctl --user list-unit-files";
        "reset" = "systemctl --user reset-failed";
        "cb" = "cd `lsbm.d | fzy -p 'cd to bookmark: '`";
        "cdp" = "cd `lsproj | fzy -p 'cd to project: '`";
        "v" = "vagrant";
        "ncu-update" = "nix-shell -p nodePackages.npm-check-updates --command 'ncu -u'";
     };
   };

}
