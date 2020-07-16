{ profile, pkgs, lib, ... }:
with profile;
{
  home.packages = with pkgs; [
    nix-zsh-completions
    fzy
    skim
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
          src =
            let
              origSrc = pkgs.fetchFromGitHub {
                owner = "b4b4r07";
                repo = "enhancd";
                rev = "f0f894029d12eecdc36c212fa3ad14f55468d1b7";
                sha256 = "1qk2fa33jn4j3xxaljmm11d6rbng6d5gglrhwavb72jib4vmkwyb";
                # date = 2020-02-11T14:27:32+09:00;
              };
              drv = pkgs.stdenv.mkDerivation {
                name = "copy-enhancd";
                src = origSrc;
                buildPhase = "";
                installPhase = ''
                mkdir -p $out
                cp -ra -t $out $src/src $src/lib $src/config.ltsv $src/init.sh
                '';
              };
            in drv;
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
          name = "zsh-fzy";
          src = pkgs.fetchFromGitHub {
            owner = "aperezdc";
            repo = "zsh-fzy";
            rev = "923364fabf5e8731f2f0d02c66946a7b6a4c3b13";
            sha256 = "15kc5qcwfmi8p1nyykmnjp32lz8zn1ji8w6aly1pfcg0l62wm26q";
            # date = 2019-09-25T15:40:28+03:00;
          };
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "c4c419edb98c54e442f743708f3f1159d6735241";
            sha256 = "197qmbc35byqcs4rjf3vin2mbwsc3m4i6q9zd50q5jpk8bij2gd8";
            # date = 2020-04-02T19:05:33+02:00;
          };
        }
        {
          name = "nix-shell";
          src =  pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "a65382a353eaee5a98f068c330947c032a1263bb";
            sha256 = "0l41ac5b7p8yyjvpfp438kw7zl9dblrpd7icjg1v3ig3xy87zv0n";
            # date = 2019-12-20T12:15:36+01:00;
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

# Configuration for zsh-fzy plugin https://github.com/aperezdc/zsh-fzy
bindkey '\eq' fzy-proc-widget
bindkey '\ew' fzy-cd-widget
bindkey '\ee' fzy-file-widget
bindkey '\er' fzy-history-widget
zstyle :fzy:file command fd -t f
zstyle :fzy:cd command fd -t d

# Support directory tracking on emacs-libvterm.
# https://github.com/akermu/emacs-libvterm#directory-tracking
function chpwd() {
    print -Pn "\e]51;A$(pwd)\e\\";
}

# zsh=${profile.path.binDir}/zsh
# if [[ -x "$zsh" ]]; then
#    export SHELL="$zsh"
# fi

export NIX_BUILD_SHELL=bash

# Use gpg-agent as ssh-agent.
gpg-connect-agent /bye
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
'';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "ls" = "ls --color=auto";
        "la" = "ls -a";
        "ll" = "ls -l";
        "rm" = "rm -i";
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
      };

      profileExtra = ''
emulate sh
if [ -f /etc/profile ] && [ ! -v __ETC_PROFILE_DONE ]; then
  . /etc/profile
fi
if [ -f ~/.profile ]; then
  . ~/.profile
fi
emulate zsh

source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
'';
   };

}
