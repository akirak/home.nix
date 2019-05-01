{ pkgs, lib, ... }:
with
  lib.mkIf;
let
  homeDirectory = builtins.getEnv "HOME";
  channelsDir = "${homeDirectory}/.nix-defexpr/channels";
  hmConfigFile = "${homeDirectory}/.emacs.d/nix/home.nix";
  binDir = "${homeDirectory}/.nix-profile/bin";
  hmSessionBin = "${binDir}/hm-session";
  scriptSrcDir = "${homeDirectory}/.emacs.d/nix/scripts";
  # You have to create a symlink from identity.nix to one of the
  # identity.*.nix files in the repository
  identity = import ./identity.nix {};
  prefs = identity.preferences;
  fullname = identity.fullname;
  email = identity.email;
  language = identity.language;
  platform = identity.platform;
  isNixOS = identity.platform.isNixOS;
  zDotDir = ".config/zsh";
  zPromptDir = ".config/zsh/prompt";
  zshPurePrompt = pkgs.fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "e7036c43487fedf608a988dde54dd1d4c0d96823";
    sha256 = "10mdk4dn2azzrhymx0ghl8v668ydy6mz5i797nmbl2ijx9hlqb3v";
    # date = 2019-03-21T18:29:27+02:00;
  };
in
{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays =
      let path = ./overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

  manual = {
    # Install the HTML manual for offline browsing.
    html.enable = true;
    # Install the JSON-formatted option list for various use (in the future).
    json.enable = true;
    # Install the man page.
    manpages.enable = true;
  };

  news = {
    # Print updates.
    display = "notify";
  };

  # TODO; Enable fonts installed through home.packages.
  # This is only necessary on non-NixOS systems.
  fonts.fontconfig = {
    enable = true;
  };

  gtk = import ./gtk.nix {};

  xdg = {
    enable = true;

    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    cacheHome = "${homeDirectory}/.cache/";
  };

  # The following configuration is used if you start an X session using xinit.
  # Configure ~/.xinitrc.
  # xsession = {
  #   enable = true;
  #   windowManager.command =
  #     "${pkgs.herbstluftwm}/bin/herbstluftwm --locked";
  #   scriptPath = ".xinitrc";
  # };

  home = {
    # The set of packages to appear in the user environment.
    packages = with pkgs; [
      ripgrep
      mlocate
      gopass
      nox
      nix-prefetch-git
      nix-zsh-completions
      # Fonts
      overpass
      powerline-fonts
      # Icons
      emacs-alt-icon
      suru-plus-terminal-icons
      # Other graphical apps
      tilix
      # Scripts
      my-scripts
    ] ++
    (if platform.isWayland
    then [ wl-clipboard ]
    else []);

    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];

  #   # Disable keyboard management
    keyboard = null;
    # Keyboard management needed for running a X session through xinit.
    # keyboard = {
    #   layout = "us";
    #   options = [ "ctrl:nocaps" ];
    # };

    language = language;

    sessionVariables = {
      EDITOR = "emacsclient";
      NIX_PATH = "nixpkgs=${channelsDir}/nixpkgs:${channelsDir}";
      HOME_MANAGER_CONFIG = hmConfigFile;
    } // identity.locale;

    file = {
      "${zPromptDir}/prompt_spaceship_setup".source
        = "${pkgs.fetchFromGitHub {
          owner = "denysdovhan";
          repo = "spaceship-prompt";
          rev = "d9f25e14e7bec4bef223fd8a9151d40b8aa868fa";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
          # date = 2019-03-11T19:03:37+02:00;
          }
        }/spaceship.zsh";

      "${zPromptDir}/prompt_pure_setup".source = "${zshPurePrompt}/pure.zsh";
      "${zPromptDir}/async".source = "${zshPurePrompt}/async.zsh";

      ".local/share/applications/emacs.desktop".text = ''
[Desktop Entry]
Version=1.0
Name=GNU Emacs (with custom Environment)
GenericName=Text Editor
Comment=GNU Emacs is an extensible, customizable text editor - and more
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
TryExec=${binDir}/emacs-server-open
Exec=${hmSessionBin} emacs-server-open %F
Icon=emacs
Type=Application
Terminal=false
Categories=Utility;Development;TextEditor;
StartupWMClass=Emacs
Keywords=Text;Editor;
Actions=new-frame;new-session;debug-session;

[Desktop Action new-frame]
Name=New emacscslient frame
Exec=${binDir}/emacsclient -c

[Desktop Action new-session]
Name=New session without server
Exec=${hmSessionBin} emacs

[Desktop Action debug-session]
Name=Start in debug mode
Exec=${hmSessionBin} emacs --debug-init
'';

      ".local/share/applications/com.gexperts.Tilix.desktop".text = ''
[Desktop Entry]
Version=1.0
Name=Tilix
Comment=A tiling terminal for Gnome
Keywords=shell;prompt;command;commandline;cmd;
Exec=${hmSessionBin} tilix
Terminal=false
Type=Application
StartupNotify=true
Categories=System;TerminalEmulator;X-GNOME-Utilities;
Icon=terminal
DBusActivatable=true
Actions=new-window;new-session;preferences;

[Desktop Action new-window]
Name=New Window
Exec=${hmSessionBin} tilix --action=app-new-window

[Desktop Action new-session]
Name=New Session
Exec=${hmSessionBin} tilix --action=app-new-session

[Desktop Action preferences]
Name=Preferences
Exec=${hmSessionBin} tilix --preferences
'';

      # Like above, add all icons in ~/.nix-profile/share/icons to
      # ~/.local/share/icons. This is unnecessary if I could set
      # XDG_DATA_DIRS as read by Garcon.
      ".local/share/icons/favorites" = {
        source = "${homeDirectory}/.nix-profile/share/icons/favorites";
      };
    };
  };

  programs = {

    home-manager = {
      enable = true;
      path = "~/.nix-defexpr/channels/home-manager";
    };

    emacs = {
      enable = true;
    };

    git = {
      enable = true;

    #   userName = mkIf prefs.addGlobalGitIdentity identity.fullname;
    #   userEmail = mkIf prefs.addGlobalGitIdentity identity.email;

      aliases = {
        co = "checkout";
        sub = "submodule";
        su = "submodule update --init --recursive";
        l1 = "log --oneline";
      };

      extraConfig = {
        github.user = identity.github.user;

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
      enable = prefs.useBrowserPass;
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

    zsh = {
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

fpath+=~/${zPromptDir}
autoload -Uz promptinit
promptinit
prompt pure
# https://github.com/sindresorhus/pure/issues/188
prompt_pure_set_title() {}

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

  };

  services = {
    # dunst = {};
    # flameshot = {};
    # gpg-agent = {};
    # TODO: Run keybase service
    # kbfs = {};
    # keybase = {};
    # mbsync = {};
    # Run syncthing service. This is triggered by default.target
    syncthing = {
      enable = true;
      tray = false;
    };
    # udiskie = {};

    # Only on NixOS
    # random-background = {};
  };

  systemd.user = {
  #   paths = {};
    services = {
      # Based on https://askubuntu.com/questions/1105123/how-to-start-emacs-as-service
      emacs = {
        Unit = {
          Description = "Emacs session with relevant services started";
          Wants = [
            "default.target"
          ];
          After = [
            "default.target"
          ];
        };
        Service = {
          Type = "forking";

          ExecStart = "${hmSessionBin} emacs --daemon";

          ExecStop = "${binDir}/emacsclient --eval \"(progn (save-some-buffers t) (setq kill-emacs-hook nil) (kill-emacs))\"";

          Restart = "on-failure";

          Environment = [
            "DISPLAY=:0"
            # "SSH_AUTH_SOCK=/run/user/1000/keyring/ssh"
            # Maybe necessary (see https://datko.net/2015/10/08/emacs-systemd-service/)
            # "GPG_AGENT_INFO=/run/user/1000/keyring/gpg:0:1"
          ];

        };
      };

      # TODO: Backup ~/org periodically
    };
    targets = {};
    timers = {};
  #   sessionVariables = {};
  #   # startServices = false;
  #   systemctlPath = "";
  };

}

# Local Variables:
# compile-command: "home-manager build"
# End:
