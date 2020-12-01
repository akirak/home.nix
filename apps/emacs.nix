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

}
