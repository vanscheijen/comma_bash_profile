,clip () {
    local f_usage="<file | string>"
    local f_info="Put <file> or <string> into X or Wayland clipboard"

    if [[ ! "$1" ]]; then
        ,,usage
    elif ,,have wl-copy; then
        [[ -f "$1" ]] && wl-copy < "$1" || wl-copy "$1"
    elif ,,have xclip; then
        [[ -f "$1" ]] && xclip -selection clipboard "$1" || xclip -selection clipboard <<< "$1"
    else
        ,notice "Install wl-copy or xclip to use this function"
    fi
}

