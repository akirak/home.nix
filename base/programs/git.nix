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
    # Only on WSL
    # core.fileMode = false;

    # Increase the size of post buffers to prevent hung ups of git-push.
    # https://stackoverflow.com/questions/6842687/the-remote-end-hung-up-unexpectedly-while-git-cloning#6849424
    http.postBuffer = "524288000";
  };

  ignores = [
    ".direnv"
  ];

  signing = {
    key = "5B3390B01C01D3E";
  };
}
//
lib.optionalAttrs preferences.addGlobalGitIdentity {
  userName = identity.fullname;
  userEmail = identity.email;
}
