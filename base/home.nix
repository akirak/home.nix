{ profile, pkgs, lib, ... }:
with profile;
{
  # The set of packages to appear in the user environment.
  packages = with pkgs; [
    locale
    nox
    nix-prefetch-git
    my-scripts
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

  sessionVariables = {
    NIX_PATH = "nixpkgs=${path.channelsDir}/nixpkgs:${path.channelsDir}";
    HOME_MANAGER_CONFIG = builtins.getEnv "HOME_MANAGER_CONFIG";
  }
  # Apply the locale settings in the profile
  // profile.locale;

}