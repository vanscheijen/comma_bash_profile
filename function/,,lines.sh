,,lines () {
    if [[ "$LINES" -gt 0 ]]; then
        printf "$LINES"
    else
        local lines
        lines="$(stty size)"
        printf "${lines%% *}"
    fi
}

