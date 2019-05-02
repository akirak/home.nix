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
      startupWmClass = cfg.startupWmClass;
      startupNotify = false;
    };
    in ''
[Desktop Entry]
Version=1.0
Name=${params.name}
TryExec=${params.tryExec}
Exec=${params.exec}
Icon=${params.icon}
Type=${params.type}
Terminal=${if params.terminal then "true" else "false"}
StartupWMClass=${params.startupWmClass}
StartupNotify=${if params.startupNotify then "true" else "false"}
'';

  mkApplicationEntry = cfg:
    mkEntry (cfg // {
      type = "Application";
    });

}
