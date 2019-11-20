{ profile, pkgs, lib, ... }:
with profile;
{
  enable = true;

  aliases = {
    co = "checkout";
    sub = "submodule";
    su = "submodule update --init --recursive";
    l1 = "log --oneline";
  };

  extraConfig = {
    github.user = profile.github.user;

    "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";

    core.autocrlf = "input";
  };

  ignores = [];

  # TODO: Define programs.git.signing
  # signing = null;
}
//
lib.optionalAttrs preferences.addGlobalGitIdentity {
  userName = identity.fullname;
  userEmail = identity.email;
}
