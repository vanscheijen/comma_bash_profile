,clip () {
    if [[ ! "$1" ]]; then
        ,error "Missing stdin stream or parameter : <file | string>"
    elif ,have wl-copy; then
        [[ -f "$1" ]] && wl-copy < "$1" || wl-copy "$1"
    elif ,have xclip; then
        [[ -f "$1" ]] && xclip -selection clipboard "$1" || xclip -selection clipboard <<< "$1"
    else
        ,notice "Install wl-copy or xclip to use this function"
    fi
}

