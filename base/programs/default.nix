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

    # TODO: Configure autorandr (possibly unnecessary?)
    # autorandr = {
    #   enable = true;
    # };

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

}
