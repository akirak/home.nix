function clean_path() {
    local IFS=:
    local newpath=""
    for dir in $PATH; do
        if [[ "$dir" == /mnt/c/@(Windows|Program Files|Program Files \(x86\))/* ]]; then
            continue
        fi
        if [[ -z "$newpath" ]]; then
            newpath="$dir"
        else
            newpath="$newpath:$dir"
        fi
    done
    # Allow access to powershell.exe
    newpath="$newpath:/mnt/c/Windows/System32/WindowsPowerShell/v1.0"

    PATH="$newpath"
}

clean_path
export PATH

# Set DISPLAY to 0 unless it has been already set
# DISPLAY=${DISPLAY:-:0}
# export DISPLAY

# Set the display for WSL 2
DISPLAY=`grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0
export DISPLAY

LIBGL_ALWAYS_INDIRECT=1
export LIBGL_ALWAYS_INDIRECT
