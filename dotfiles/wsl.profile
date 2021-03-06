function clean_path {
    local IFS=:
    local newpath=""
    for dir in $PATH; do
        # if [ "$dir" == /mnt/c/@(Windows|Program Files|Program Files \(x86\))/* ]; then
        if echo $dir | grep -E "^/mnt/c/(Windows|Program Files|Program Files \(x86\))/" >/dev/null; then
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
