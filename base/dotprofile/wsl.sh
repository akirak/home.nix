origifs="$IFS"

if [[ "$0" = zsh ]]; then
    emulate bash
fi

IFS=:
declare -a newpath
for dir in $PATH; do
    case "$dir" in
        /mnt/c/WINDOWS) ;;
        /mnt/c/Windows) ;;
        /mnt/c/WINDOWS/*) ;;
        /mnt/c/Windows/*) ;;
        /mnt/c/Program\ Files/*) ;;
        /mnt/c/Program\ Files\ \(x86\)/*) ;;
        *)
            newpath+=("$dir")
            ;;
    esac
done

if [[ "$PATH" != *:/mnt/c/Windows/System32/WindowsPowerShell/v1.0 ]]; then
    # Allow access to powershell.exe
    newpath+=("/mnt/c/Windows/System32/WindowsPowerShell/v1.0")
fi

IFS="$origifs"

PATH=

for dir in ${newpath[*]}; do
    PATH="$PATH${PATH:+:}$dir"
done

export PATH

unset newpath
unset origifs

# Set DISPLAY to 0 unless it has been already set
# DISPLAY=${DISPLAY:-:0}
# export DISPLAY

# Set the display for WSL 2
if ! [[ -v DISPLAY ]]; then
    DISPLAY=`grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0
    export DISPLAY
fi

LIBGL_ALWAYS_INDIRECT=1
export LIBGL_ALWAYS_INDIRECT

if [[ "$0" = zsh ]]; then
    emulate zsh
fi
