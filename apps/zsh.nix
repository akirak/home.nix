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
          src = pkgs.nur.akirak.zsh-pure-prompt;
        }
        {
          name = "enhancd";
          # file = "init.sh";
          src = pkgs.nur.akirak.zsh-enhancd;
        }
        {
          name = "fzy";
          src = pkgs.nur.akirak.zsh-fzy;
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.nur.akirak.zsh-fast-syntax-highlighting;
        }
        {
          name = "nix-shell";
          src =  pkgs.nur.akirak.zsh-nix-shell;
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

        STARDICT_DATA_DIR = "${profile.path.homeDirectory}/.nix-profile/share/stardict";
        "GOPATH" = "${builtins.getEnv "HOME"}/misc/go";
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

function mr-all() {
  for d in ~ /public /private; do
    [[ -d $d ]] || continue
    cd $d && mr "$@"
  done
}

# if [[ -f ~/.asdf/asdf.sh ]]; then
#    source ~/.asdf/asdf.sh
# fi
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
        "nsearch" = "nix search --no-update-lock-file nixpkgs";
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

if [[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
'';
   };

}
