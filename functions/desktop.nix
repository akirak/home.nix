rec {

  mkEntry = cfg:
    let params =
    {
      name = cfg.name;
      # genericName = cfg.genericName;
      # comment = cfg.comment;
      terminal = false;
      type = cfg.type;
      icon = cfg.icon;
      exec = cfg.exec;
      tryExec = cfg.tryExec;
      mimeType = cfg.mimeType;
      dBusActivatable = if cfg ? dBusActivatable
                        then cfg.dBusActivatable
                        else false;
    };
    in ''
     [Desktop Entry]
     Version=1.0
     Name=${params.name}
     TryExec=${params.tryExec}
     Exec=${params.exec}
     Icon=${params.icon}
     Type=${params.type}
     Terminal=${boolToString params.terminal}
     DBusActivatable=${boolToString params.dBusActivatable}
     ${if cfg ? startupWmClass then "StartupWMClass=" + cfg.startupWmClass else ""}
     ${if cfg ? startupNotify then "StartupNotify=" + boolToString cfg.startupNotify else ""}
'';

  mkApplicationEntry = cfg:
    mkEntry (cfg // {
      type = "Application";
    });

  boolToString = b: if b then "true" else "false";

}
