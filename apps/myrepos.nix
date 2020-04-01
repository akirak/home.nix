{ profile, desktop, pkgs, lib, ... }:
with profile.path;
{
  home.packages = with pkgs; [
    myrepos
  ];

  home.file.".local/share/applications/mr-update.desktop".text =
    let
      wmClass = "mr-update";
    in
      desktop.mkApplicationEntry {
        name = "mr update";
        exec = "${binDir}/alacritty --class ${wmClass} -e sh -c 'cd ~; mr up; read'";
        tryExec = "${binDir}/mr";
        # TODO: Replace with an icon which better fits the app
        icon = "alacritty-term";
        startupWmClass = wmClass;
        startupNotify = false;
      };

  # mrconfig for all machines
  home.file.".mrconfig".text = ''
[DEFAULT]
# Define global commands here
update = git safe-update

[$HOME/.emacs.d]
checkout =
      git clone -b maint --recursive https://github.com/akirak/emacs.d.git .emacs.d
      cd .emacs.d; make
update = ./update.bash

[home.nix]
checkout = git clone https://github.com/akirak/home.nix
update =
      if git safe-update; then
          if [ -f Makefile ]; then
              make
          fi
      elif [ $? -eq 2 ]; then
          exit 0
      else
          exit 1
      fi

[$HOME/lib/organiser]
checkout =
      git clone git@github.com:akirak/organiser.git
      cd organiser; make install-hooks

[$HOME/lib/programming]
checkout =
      git clone git@github.com:akirak/programming.git
'';

  # mrconfig for personal machines
  home.file.".mrconfig.personal".text = ''
[DEFAULT]
include = cat ~/.mrconfig

[$HOME/lib/blog]
checkout = git clone -b drafts --recursive git@github.com:akirak/jingsi-space-blog.git blog
'';

}
