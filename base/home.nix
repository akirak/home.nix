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
    gitbatch
    bashcaster
    nox
    niv
    nix-prefetch-git
    trash-cli
    my-scripts
    xclip
    (lib.mkIf profile.platform.isWsl wsl-open)
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
      })
    # Apply the locale settings in the profile
    // profile.locale;

}
//
lib.optionalAttrs profile.platform.isWsl {
  file.".profile".source = ./dotprofile/wsl.sh;
}
