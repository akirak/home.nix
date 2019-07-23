{ profile, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    myrepos
  ];

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

[$HOME/lib/emacs]
checkout = git clone https://github.com/akirak/emacs-config-library.git emacs
'';

}