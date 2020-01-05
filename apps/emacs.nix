{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  programs.emacs = {
    enable = true;
    # Emacs 27.0.50 failed to start up with my Emacs config.
    # I will try it later.
    # package = pkgs.emacs-overlay.emacsGit;
    extraPackages = epkgs:
      with epkgs; [
        melpaStablePackages.emacsql-sqlite
        emacs-libvterm
        mozc
        pdf-tools
        elisp-ffi
        exwm
        beancount
      ];
    overrides = self: super: {
      mozc = with pkgs;
        let
          japanese_usage_dictionary = pkgs.fetchFromGitHub {
            owner  = "hiroyuki-komatsu";
            repo   = "japanese-usage-dictionary";
            rev    = "a4a66772e33746b91e99caceecced9a28507e925";
            sha256 = "10kcx108v0yjdsf71yi7c9igy2i92gan682gfv78sbmcazx80xda";
            # date = 2018-07-01T13:01:10+09:00;
          };
          python = python2;
          gyp = python27Packages.gyp;
          libxcb = xorg.libxcb;
          protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
          fetchpatch = pkgs.fetchpatch;
        in
          clangStdenv.mkDerivation rec {
            inherit (super.mozc) name version meta src;

            nativeBuildInputs = [ which ninja python gyp pkgconfig ];
            buildInputs = [ protobuf gtk2 zinnia libxcb ];

            patches = [
              # https://github.com/google/mozc/pull/444 - fix for gcc8 STL
              (fetchpatch {
                url = "https://github.com/google/mozc/commit/82d38f929882a9c62289b179c6fe41efed249987.patch";
                sha256 = "07cja1b7qfsd3i76nscf1zwiav74h7d6h2g9g2w4bs3h1mc9jwla";
              })
            ];

            postUnpack = ''
              rmdir $sourceRoot/src/third_party/japanese_usage_dictionary/
              ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
            '';

            configurePhase = ''
              export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1"
              cd src && python build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc --noqt
            '';

            buildPhase = ''
              PYTHONPATH="$PWD:$PYTHONPATH" python build_mozc.py build -c Release \
                server/server.gyp:mozc_server \
                unix/emacs/emacs.gyp:mozc_emacs_helper
              '';

            installPhase = ''
              install -d        $out/share/licenses/mozc
              head -n 29 server/mozc_server.cc > $out/share/licenses/mozc/LICENSE
              install -m 644    data/installer/*.html     $out/share/licenses/mozc/
              install -d $out/lib/mozc
              install -D -m 755 out_linux/Release/mozc_server $out/lib/mozc/mozc_server
              install -d $out/bin
              install    -m 755 out_linux/Release/mozc_emacs_helper $out/bin/mozc_emacs_helper
              install -d        $out/share/doc/mozc
              install -m 644    data/installer/*.html         $out/share/doc/mozc/
              install -d        $out/share/emacs/site-lisp/elpa/mozc
              elisp=$out/share/emacs/site-lisp/elpa/mozc/mozc.el
              install -m 644    unix/emacs/mozc.el            $elisp
              sed --in-place s/\"mozc_emacs_helper\"/\"$(echo $out/bin/ | sed s/\\//\\\\\\//g)mozc_emacs_helper\"/ $elisp
            '';
          };

      # Temporarily override the recipe for the package.
      emacs-libvterm = lib.overrideDerivation super.emacs-libvterm (attrs: rec {
        name = "emacs-libvterm-${version}";
        version = "0.0.20191123";
        src = pkgs.fetchFromGitHub {
          owner = "akermu";
          repo = "emacs-libvterm";
          rev = "8a6e5fe3c95ba4a5520ef1cf7b31a2e45b420b8e";
          sha256 = "1bbl2rdq5mq3kya31ppl14a7c3bvaqs3bn2aplmpvd4idlrbk5qh";
          # date = 2019-12-09T21:15:47+08:00;
        };
      });

      beancount = self.melpaBuild {
        pname = "beancount";
        version = "20191230";

        src = pkgs.fetchFromBitbucket {
          owner = "blais";
          repo = "beancount";
          rev = "master";
          sha256 = "1wcp9kgz90xbp8hch555ip61pa094gw8p9iay92mvw35ysar55xi";
        };

        recipe = pkgs.writeText "recipe" ''
(beancount
  :fetcher bitbucket
  :repo "blais/beancount"
  :files ("editors/emacs/*.el" (:exclude "*-test.el")))
'';
      };

     };
  };

  home.packages = with pkgs; [
    ripgrep
    exa
    fd
    bat
    mlocate
    gopass
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
    # for some packages (e.g. treemacs)
    python3
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

  home.file.".local/share/applications/emacs-custom-restart.desktop".text =
    desktop.mkApplicationEntry {
      name = "Restart the Emacs service";
      exec = "systemctl --user restart emacs.service";
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
      ExecStart = "${hmSessionBin} emacsclient -a '' -c";

      ExecStop = "${binDir}/emacsclient --eval \"(progn (save-some-buffers t) (kill-emacs))\"";

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

  home.file.".local/share/applications/emacs-debug-init.desktop".text =
    desktop.mkApplicationEntry {
      name = "Debug Emacs startup (--debug-init)";
      exec = "systemctl --user restart emacs-debug-init.service";
      tryExec = "${binDir}/emacs";
      startupWmClass = "Emacs";
      icon = "emacs";
    };
}
