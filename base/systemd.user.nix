{ profile, pkgs, lib, ... }:
with profile.path;
{
  #   paths = {};
    services = {
      "notify-failure@" = {
        Unit = {
          Description = "Notify failure of a service";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${binDir}/notify-desktop '%i service has exited.'";
        };
      };

      # Based on https://askubuntu.com/questions/1105123/how-to-start-emacs-as-service
      emacs = {
        Unit = {
          Description = "Emacs session with relevant services started";
          Wants = [
            "default.target"
          ];
          After = [
            "default.target"
          ];
          OnFailure = [
            "notify-failure@emacs.service"
          ];
        };
        Service = {
          Type = "forking";

          ExecStart = "${hmSessionBin} emacs --daemon";

          ExecStartPost = "${binDir}/notify-desktop -u low -a Emacs 'Emacs service successfully started'";

          ExecStop = "${binDir}/emacsclient --eval \"(progn (save-some-buffers t) (setq kill-emacs-hook nil) (kill-emacs))\"";

          Restart = "on-failure";

          Environment = [
            "DISPLAY=:0"
            # "SSH_AUTH_SOCK=/run/user/1000/keyring/ssh"
            # Maybe necessary (see https://datko.net/2015/10/08/emacs-systemd-service/)
            # "GPG_AGENT_INFO=/run/user/1000/keyring/gpg:0:1"
          ];

        };
      };

      xephyr = {
        Unit = {
          Description = "Nested X server";
          StopWhenUnneeded = true;
        };
        Service = {
          Type = "simple";

          ExecStart = "${binDir}/xephyr-launcher :2";

          Environment = [
            "DISPLAY=:0"
            "PATH=${binDir}:/usr/bin:/bin"
          ];
        };
      };

      exwm = {
        Unit = {
          Description = "Emacs Window Manager";
          BindsTo = [
            "xephyr.service"
          ];
          After = [
            "xephyr.service"
          ];

          OnFailure = [
            "notify-failure@exwm.service"
          ];

        };
        Service = {
          Type = "simple";

          # TODO: Save all buffers in existing Emacs sessions

          ExecStart = "${hmSessionBin} emacs --exwm";

          Environment = [
            "DISPLAY=:2"
          ];

        };
      };

      backup-org =
      let repo = "%h/org";
      in {
        Unit = {
          Description = "Backup contents in ~/org to the Git repository inside itself";
          AssertPathIsDirectory = "${repo}/.git";
        };
        Service = {
          Type = "simple";
          WorkingDirectory = repo;
          ExecStart = "${binDir}/backup-org-git";
        };
      };

      # An alternative service unit for kbfs.
      #
      # To use this service, you have to take the following additional steps:
      #
      # 1. Install a package that provides =fusermout=. On Debian,
      # this is fuse package. Note that fusermount 2.9.9 from nixpkgs
      # doesn't seem to work, while fusermount 2.9.7 from the Debian
      # repo works.
      #
      # 2. Create /keybase directory owned by the user.
      kbfs =
      let
        mountPoint = "/keybase";
      in
      {
        Unit = {
          Description = "Keybase File System";
          Requires = [ "keybase.service" ];
          After = [ "keybase.service" ];
          AssertPathIsDirectory = mountPoint;
          # Use fusermount provided by the OS distribution
          AssertFileIsExecutable = "/bin/fusermount";
        };

        Service =
        {
          Environment = [
            "KEYBASE_SYSTEMD=1"
          ];
          ExecStart ="${pkgs.kbfs}/bin/kbfsfuse ${mountPoint}";
          # Use fusermount provided by the OS distribution
          ExecStopPost = "/bin/fusermount -u ${mountPoint}";
          Restart = "on-failure";
          PrivateTmp = true;
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };

    };
    targets = {};
    timers = {
      backup-org = {
        Unit = {
          Description = "Run backup-org.service periodically";
        };
        Timer = {
          OnUnitActiveSec = "5m";
        };
        Install = {
          WantedBy = [
            "default.target"
          ];
        };
      };
    };
  #   sessionVariables = {};
  #   # startServices = false;
  #   systemctlPath = "";
  }
