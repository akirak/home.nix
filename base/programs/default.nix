attrs@{ profile, pkgs, lib, ... }:
with profile;
{

    home-manager = {
      enable = true;
      path = "~/.nix-defexpr/channels/home-manager";
    };

    git = import ./git.nix attrs;

    ssh = {
      enable = true;
    };

    browserpass = {
      enable = preferences.useBrowserPass;
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
      enableNixDirenvIntegration = true;
    };

    jq = {
      enable = true;
      # colors =
    };

    man = {
      enable = true;
    };

}
