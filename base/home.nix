{ profile, pkgs, lib, ... }:
with profile;
{
  # The set of packages to appear in the user environment.
  packages = with pkgs; [
    (lib.mkIf (! profile.platform.isNixOS) nixFlakes)
    dejavu_fonts
    killall
    locale
    gnumake
    gnupg
    gitAndTools.hub
    gitAndTools.git-annex
    gitAndTools.git-annex-utils
    gitAndTools.git-remote-hg
    git-crypt
    niv
    nix-prefetch-git
    trash-cli
    nur.akirak.xephyr-launcher
    xclip
    (lib.mkIf profile.platform.isWsl nur.akirak.wsl-open)
    rclone
    nur.akirak.myrepos
    nur.akirak.bashcaster
    nur.akirak.git-safe-update

    ripgrep
    fd

    # ripgrep-all
    exa
    bat
    gopass
    mpv
    # for editing image files

    # Pinta fails to build, so I'll disable it for now
    # pinta

    # compressing image files
    # beancount
    beancount
    # icons
    # emacs-alt-icon
    # fonts
    google-fonts
    symbola
    noto-fonts-emoji
    nur.akirak.go-mono-nerd-font
    nur.akirak.hack-nerd-font
    hasklig
    nur.akirak.tinos-nerd-font
    agave
    nur.akirak.hannari-mincho-font
    nur.akirak.adobe-chinese-font
    # Since nix clears the font cache, it's better to not install
    # fonts as an Emacs package
    emacs-all-the-icons-fonts
    # hunspellDicts.en-gb-ize
    # Data for rime (Chinese input)
    # This somehow causes conflicts. I will review it later.
    # brise
  ];

  extraOutputsToInstall = [
    "doc"
    "info"
    "devdoc"
  ];

  # Disable keyboard management
  keyboard = null;

  # Keyboard management needed when you run X sessions through xinit.
  # keyboard = {
  #   layout = "us";
  #   options = [ "ctrl:nocaps" ];
  # };

  # Use the language settings from the profile.
  language = profile.language;

  sessionVariables =
    (with profile.path;
      {
        NIX_PATH = "nixpkgs=${channelsDir}/nixpkgs:${channelsDir}";
        HOME_MANAGER_CONFIG = builtins.getEnv "HOME_MANAGER_CONFIG";
        XDG_CACHE_HOME = "${homeDirectory}/.cache";
        XDG_CONFIG_HOME = "${homeDirectory}/.config";
        XDG_DATA_HOME = "${homeDirectory}/.local/share";
        ZDOTDIR = "${homeDirectory}/.config/zsh";
        EDITOR = "emacsclient";
      })
    # Apply the locale settings in the profile
    // profile.locale;

}
//
lib.optionalAttrs profile.platform.isWsl {
  file.".profile".source = ./dotprofile/wsl.sh;
}
