{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    ripgrep
    # ripgrep-all
    exa
    fd
    bat
    mlocate
    gopass
    nixfmt
    # Use dex to use counsel-linux-apps on NixOS
    dex
    # org-babel
    graphviz
    plantuml
    # gif-screencast
    scrot
    imagemagick
    gifsicle
    gif-progress
    mpv
    # for editing image files
    pinta
    # compressing image files
    pngquant
    # for document conversion
    unoconv
    pandoc
    # needed for helm-dash
    sqlite
    # beancount
    beancount
    # for some packages (e.g. treemacs)
    # python3
    # Dhall
    easy-dhall-nix.dhall-simple
    easy-dhall-nix.dhall-lsp-simple
    easy-dhall-nix.dhall-json-simple
    # icons
    # emacs-alt-icon
    # fonts
    google-fonts
    go-mono
    hack-font
    hasklig
    tinos
    agave
    hannari-mincho-font
    adobe-chinese
    # Since nix clears the font cache, it's better to not install
    # fonts as an Emacs package
    emacs-all-the-icons-fonts
    # ispell
    ispell
    hunspell
    hunspellDicts.en-us
    hunspellDicts.en-gb-ise
    # hunspellDicts.en-gb-ize
    # Data for rime (Chinese input)
    # This somehow causes conflicts. I will review it later.
    # brise
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

  home.file.".local/share/applications/emacs-custom.desktop".text =
    desktop.mkApplicationEntry {
      name = "GNU Emacs (with custom Environment)";
      genericName = "Text Editor";
      keywords = "Text;Editor;";
      comment = "GNU Emacs is an extensible, customizable text editor - and more";
      mimeType = "text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;";
      exec = "${nixBinDir}/emacs-server-open %F";
      tryExec = "${binDir}/emacs-server-open";
      startupWmClass = "Emacs";
      categories = "Utility;Development;TextEditor;";
      icon = "emacs";
      actions = {
        new-frame = {
          name = "New emacscslient frame";
          exec = "${binDir}/emacsclient -c";
        };
        new-session = {
          exec = "${nixBinDir}/emacs";
          name = "New session without server";
        };
        debug-session = {
          exec = "${nixBinDir}/emacs --debug-init";
          name = "Start in debug mode";
        };
      };
    };

  home.file.".local/share/applications/emacs-custom-restart.desktop".text =
    desktop.mkApplicationEntry {
      name = "Restart the Emacs service";
      exec = "systemctl --user restart emacs.service";
      tryExec = "${binDir}/emacs";
      startupWmClass = "Emacs";
      icon = "emacs";
    };

  home.file.".local/share/applications/emacs-custom-stop.desktop".text =
    desktop.mkApplicationEntry {
      name = "Stop the Emacs service";
      exec = "systemctl --user stop emacs.service";
      tryExec = "${binDir}/emacs";
      startupWmClass = "Emacs";
      icon = "emacs";
    };

  # Based on https://askubuntu.com/questions/1105123/how-to-start-emacs-as-service
  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs session with relevant services started";
      Wants = [
        "default.target"
      ];
      After = [
        "default.target"
      ];
      OnFailure = [
        "notify-failure@emacs.service"
      ];
    };
    Service = {
      Type = "simple";

      # https://www.reddit.com/r/emacs/comments/b8ksfs/psa_for_new_users_emacs_261_has_the_emacs_daemon/ejyhklq/
      ExecStart = "${nixBinDir}/emacsclient -a '' -c";

      ExecStop = "${binDir}/emacsclient --eval \"(progn (save-some-buffers t) (kill-emacs))\"";

      Environment = [
        "DISPLAY=:0"
        # You should get this value by running `gpgconf --list-dirs agent-ssh-socket`
        "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh"
        # Maybe necessary (see https://datko.net/2015/10/08/emacs-systemd-service/)
        # "GPG_AGENT_INFO=/run/user/1000/keyring/gpg:0:1"
      ];
    };
  };

  # Like above, but start Emacs in debug mode
  systemd.user.services."emacs-debug-init" = {
    Unit = {
      Description = "Start Emacs with --debug-init";
    };
    Service = {
      Type = "simple";

      ExecStartPre = "${binDir}/notify-desktop 'Starting emacs --debug-init'";

      ExecStart = "${nixBinDir}/emacs --debug-init";

      Environment = [
        "DISPLAY=:0"
      ];
    };
  };

  home.file.".local/share/applications/emacs-debug-init.desktop".text =
    desktop.mkApplicationEntry {
      name = "Debug Emacs startup (--debug-init)";
      exec = "systemctl --user restart emacs-debug-init.service";
      tryExec = "${binDir}/emacs";
      startupWmClass = "Emacs";
      icon = "emacs";
    };
}
