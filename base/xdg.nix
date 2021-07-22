{ profile }:
with profile.path;
{
  enable = true;

  configHome = "${homeDirectory}/.config";
  dataHome = "${homeDirectory}/.local/share";
  cacheHome = "${homeDirectory}/.cache";

  mimeApps = {
    defaultApplications = {
      "application/epub+zip" = [
        "foliate"
      ];
    };
  };
}
