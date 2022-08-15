,open () {
    local filetype app
    if [[ -f "$@" ]]; then
        filetype=$(xdg-mime query filetype "$@")
        app=$(xdg-mime query default "$filetype")
        echo "$filetype is opened by $app"
    fi
    xdg-open "$@"
}

