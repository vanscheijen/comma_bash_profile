,forline () {
    local f_usage="[file] [command]"
    local f_info="Loops through each line in [file] or stdin and executes [command] (defaults to echo \\\$line)"

    local content
    if [[ -s "$1" ]]; then
        content=`< "$1"`
        shift
    else
        content=`,ifne cat`
    fi

    [[ -n "$@" ]] || set "echo \$line"

    local line
    while read -r line; do
        eval "$@"
    done <<< "$content"
}

