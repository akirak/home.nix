{ profile, pkgs, lib, desktop, ... }:
with profile.path; {
  home.file.".stack/config.yaml".text =
    ''
    nix:
      enable: true
    templates:
      params:
        author-email: akira.komamura@gmail.com
        author-name: Akira Komamura
        github-username: akirak
    '';
}
