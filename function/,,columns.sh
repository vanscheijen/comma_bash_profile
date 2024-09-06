,,columns () {
    if [[ "$COLUMNS" -gt 0 ]]; then
        printf "$COLUMNS"
    else
        local columns
        columns="$(stty size)"
        printf "${columns##* }"
    fi
}

