{ profile, pkgs, lib, desktop, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    # ripgrep-all
    exa
    bat
    gopass
    mpv
    # for editing image files
    pinta
    # compressing image files
    # beancount
    beancount
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
    # hunspellDicts.en-gb-ize
    # Data for rime (Chinese input)
    # This somehow causes conflicts. I will review it later.
    # brise
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

}
