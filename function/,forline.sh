,forline () {
    local f_usage="[-p] [file] [command]"
    local f_info="Loops through each line(as \$line) in [file] or stdin (default) and executes [command] (defaults to echo \\\$line). Optionally in parallel(-p)"

    local parallel=0
    if [[ "$1" == "-p" ]]; then
        parallel=1
        shift
    fi

    local content
    if [[ -s "$1" ]]; then
        content=$(< "$1")
        shift
    else
        content=$(,ifne cat)
    fi

    [[ "$content" ]] || { ,,usage; return; }

    [[ -n "$@" ]] || set "echo \"\$line\""

    local line
    while IFS= read -r line; do
        if [[ "$parallel" == 1 ]]; then
            eval "$@" &
        else
            eval "$@"
        fi
    done <<< "$content"
}

