{ profile, pkgs, lib, ... }:
{
  nixpkgs = import ./nixpkgs.nix {};
  xdg = import ./xdg.nix { inherit profile; };
  home = import ./home.nix { inherit profile pkgs lib; };
  programs = import ./programs { inherit profile pkgs lib; };
  services= import ./services.nix { inherit profile pkgs lib; };
  systemd.user = import ./systemd.user.nix { inherit profile pkgs lib; };

  manual = {
    # Install the HTML manual for offline browsing.
    html.enable = true;
    # Install the JSON-formatted option list for various use (in the future).
    json.enable = true;
    # Install the man page.
    manpages.enable = true;
  };

  news = {
    # Print updates.
    display = "notify";
  };

  # TODO; Enable fonts installed through home.packages.
  # This is only necessary on non-NixOS systems.
  fonts.fontconfig = {
    enable = false;
  };

  gtk.enable = false;

  # The following configuration is used if you start an X session using xinit.
  # Configure ~/.xinitrc.
  # xsession = {
  #   enable = true;
  #   windowManager.command =
  #     "${pkgs.herbstluftwm}/bin/herbstluftwm --locked";
  #   scriptPath = ".xinitrc";
  # };
}
