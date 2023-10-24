,compress () {
    local f_usage="<archive> <file ...>"
    local f_info="Automatically compress <file ...> into <archive> (7z|xz|bz2|gz|zip)"

    [[ "$1" && "$2" ]] || { ,,usage; return; }

    local method
    [[ "$1" =~ \.xz$ ]] && method=xz
    [[ "$1" =~ \.t?bz2$ ]] && method=bz
    [[ "$1" =~ \.t?gz$ ]] && method=gz
    [[ "$1" =~ \.zip$ ]] && method=zip

    if [[ -f "$1.7z" ]]; then
        mv -f -- "$1.7z" "$1.7z.backup"
    elif [[ -f "$1" ]]; then
        mv -f -- "$1" "$1.backup"
    fi

    if [[ -z $method ]] && ,,have 7z; then
        7z a -r -snh -snl -stl -y -- "${@/%\//\/.}"
    elif [[ $method == xz ]] || [[ -z $method ]] && ,,have xz; then
        tar -cJvpaf "$@"
    elif [[ $method == bz ]] || [[ -z $method ]] && ,,have bzip2; then
        tar -cjvpaf "$@"
    elif [[ $method == gz ]] || [[ -z $method ]] && ,,have gzip; then
        tar -czvpaf "$@"
    elif [[ $method == zip ]] || [[ -z $method ]] && ,,have zip; then
        zip -r9y "$@"
    else
        ,error "No compression available"
    fi
}

