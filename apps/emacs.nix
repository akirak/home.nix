{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs:
      with epkgs; [
        melpaStablePackages.emacsql-sqlite
        emacs-libvterm
        pdf-tools
        elisp-ffi
      ];
    overrides = self: super: {
      # Temporarily override the recipe for the package.
      emacs-libvterm = lib.overrideDerivation super.emacs-libvterm (attrs: rec {
        name = "emacs-libvterm-${version}";
        version = "unstable-2019-07-22";
        src = pkgs.fetchFromGitHub {
          owner = "akermu";
          repo = "emacs-libvterm";
          rev = "301fe9fdfd5fb2496c8428a11e0812fd8a4c0820";
          sha256 = "0i1hn5gcxayqcbjrnpgczvbicq2vsyn59646ary3crs0mz9wlbpr";
        };
      });
     };
  };

  home.packages = with pkgs; [
    ripgrep
    exa
    fd
    bat
    mlocate
    gopass
    # gif-screencast
    scrot
    imagemagick
    gifsicle
    # needed for helm-dash
    sqlite
    # icons
    # emacs-alt-icon
    # fonts
    google-fonts
    fira-code
    hannari-mincho-font
    adobe-chinese
    overpass
    # ispell
    ispell
    hunspell
    hunspellDicts.en-us
    hunspellDicts.en-gb-ise
    hunspellDicts.en-gb-ize
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

  home.file.".local/share/applications/emacs.desktop".text =
    desktop.mkApplicationEntry {
      name = "GNU Emacs (with custom Environment)";
      genericName = "Text Editor";
      keywords = "Text;Editor;";
      comment = "GNU Emacs is an extensible, customizable text editor - and more";
      mimeType = "text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;";
      exec = "${hmSessionBin} emacs-server-open %F";
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
          exec = "${hmSessionBin} emacs";
          name = "New session without server";
        };
        debug-session = {
          exec = "${hmSessionBin} emacs --debug-init";
          name = "Start in debug mode";
        };
      };
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
        "emacs@debug.service"
      ];
    };
    Service = {
      Type = "forking";

      ExecStart = "${hmSessionBin} emacs --daemon";

      ExecStartPost = "${binDir}/notify-desktop -u low -a Emacs 'Emacs service successfully started'";

      ExecStop = "${binDir}/emacsclient --eval \"(progn (save-some-buffers t) (setq kill-emacs-hook nil) (kill-emacs))\"";

      Environment = [
        "DISPLAY=:0"
        # "SSH_AUTH_SOCK=/run/user/1000/keyring/ssh"
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

      ExecStart = "${hmSessionBin} emacs --debug-init";

      Environment = [
        "DISPLAY=:0"
      ];
    };
  };
}
