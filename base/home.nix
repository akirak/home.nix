{ profile, pkgs, lib, ... }:
with profile;
let
  desktop = import ../functions/desktop.nix;
in
{
# The set of packages to appear in the user environment.
packages = with pkgs; [
locale
ripgrep
mlocate
kbfs
keybase-gui
gopass
nox
nix-prefetch-git
nix-zsh-completions
fzy
notify-desktop
# If you use exwm
xorg.xorgserver
# Fonts
overpass
powerline-fonts
# Icons
emacs-alt-icon
suru-plus-terminal-icons
la-capitaine-icons
# Other graphical apps
tilix
# Scripts
my-scripts
] ++
(if platform.isWayland
then [ wl-clipboard ]
else []);

extraOutputsToInstall = [
"doc"
"info"
"devdoc"
];

#   # Disable keyboard management
keyboard = null;
# Keyboard management needed for running a X session through xinit.
# keyboard = {
#   layout = "us";
#   options = [ "ctrl:nocaps" ];
# };

language = profile.language;

sessionVariables = {
EDITOR = "emacsclient";
NIX_PATH = "nixpkgs=${path.channelsDir}/nixpkgs:${path.channelsDir}";
HOME_MANAGER_CONFIG = builtins.getEnv "HOME_MANAGER_CONFIG";
} // profile.locale;

file = with profile.path; {

".local/share/applications/emacs.desktop".text =
desktop.mkApplicationEntry {
name = "GNU Emacs (with custom Environment)";
genericName = "Text Editor";
keywords = "Text;Editor;";
comment = "GNU Emacs is an extensible, customizable text editor - and more";
mimeType = "text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;";
exec = "${hmSessionBin} emacs-server-open %F";
tryExec = "${binDir}/emacs-server-open";
startupWmClass = "Emacs";
categories = "Utility;Development;TextEditor;";
icon = "emacs";
actions = {
new-frame = {
name = "New emacscslient frame";
exec = "${binDir}/emacsclient -c";
};
new-session = {
exec = "${hmSessionBin} emacs";
name = "New session without server";
};
debug-session = {
exec = "${hmSessionBin} emacs --debug-init";
name = "Start in debug mode";
};
};
};

".local/share/applications/exwm.desktop".text =
desktop.mkApplicationEntry {
name = "EXWM";
exec = "/bin/systemctl --user start exwm.service";
tryExec = "${binDir}/Xephyr";
startupWmClass = "Xephyr";
icon = "xorg";
};

".local/share/applications/com.gexperts.Tilix.desktop".text =
desktop.mkApplicationEntry {
name = "Tilix";
keywords = "shell;prompt;command;commandline;cmd;";
comment = "A tiling terminal for Gnome";
exec = "${hmSessionBin} tilix";
tryExec = "${binDir}/tilix";
startupNotify = true;
startupWmClass = "Tilix";
categories = "System;TerminalEmulator;X-GNOME-Utilities;";
icon = "terminal";
dBusActivatable = true;
actions = {
new-window = {
name = "New Window";
exec = "${hmSessionBin} tilix --action=app-new-window";
};
new-session = {
exec = "${hmSessionBin} tilix --action=app-new-session";
name = "New Session";
};
preferences = {
exec = "${hmSessionBin} tilix --preferences";
name = "Preferences";
};
};
};

".local/share/applications/keybase.desktop".text =
desktop.mkApplicationEntry {
name = "Keybase";
exec = "/usr/bin/env PATH=${binDir}:/usr/bin:/bin ${binDir}/keybase-gui";
tryExec = "${binDir}/keybase-gui";
icon = "keybase";
startupWmClass = "Keybase";
};

# Like above, add all icons in ~/.nix-profile/share/icons to
# ~/.local/share/icons. This is unnecessary if I could set
# XDG_DATA_DIRS as read by Garcon.
".local/share/icons/favorites" = {
source = "${homeDirectory}/.nix-profile/share/icons/favorites";
};
};
}
