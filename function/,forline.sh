,forline () {
    local f_usage="[-p] [file | stdin] <command>"
    local f_info="Loops through each line(as \$line) in [file] or stdin (default) and executes <command> (defaults to echo \\\$line). Optionally in parallel with [-p]"

    local parallel=0
    if [[ "$1" == "-p" ]]; then
        parallel=1
        shift
    fi

    local data="$1"
    [[ -s "$data" && ! -x "$data" ]] && { data="$(< "$data")"; shift; } || data="$(,ifne cat)" || { ,,usage; return; }

    [[ -n "$@" ]] || set 'echo "$line"'
    [[ "$@" =~ \$line ]] || set "$@" '"$line"'

    local line
    while IFS= read -r line; do
        if [[ "$parallel" == 1 ]]; then
            eval "$@" &
        else
            eval "$@"
        fi
    done <<< "$data"
}

