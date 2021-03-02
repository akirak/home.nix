{ ... }:
{
  systemd.user.services = {
    # Based on https://github.com/adam-savard/keychron-k2-function-keys-linux
    keychron = {
      Unit = {
        Description = "Workaround to make the function keys on Keychron keyboards work";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'";
      };
      Install = {
        WantedBy = ["multi-user.target"];
      };
    };
  };
}
