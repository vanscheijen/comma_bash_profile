,forline () {
    local f_usage="[-p] [file | stdin] <command>"
    local f_info="Loops through each line(as \$line) in [file] or stdin (default) and executes <command> (defaults to echo \\\$line). Optionally in parallel with [-p]"

    local -i parallel=0 proc=0 fd
    if [[ "$1" == "-p" ]]; then
        ,,have nproc && parallel=$(($(nproc) * 2)) || parallel=8
        shift
    fi

    local data="$1"
    [[ -s "$data" && ! -x "$data" ]] && { data="$(< "$data")"; shift; } || data="$(,ifne cat)" || { ,,usage; return; }

    [[ -n "$@" ]] || set 'echo "$line"'
    [[ "$@" =~ \$line ]] || set "$@" '"$line"'

    ,,parallel_output() {
        if [[ $proc -ge $parallel ]]; then
            wait
            for ((i=1; i <= proc; i++)); do
                cat "/tmp/,forline-$i"
                rm -f "/tmp/,forline-$i"
            done
            proc=0
        fi
    }

    local line
    while IFS= read -r line; do
        if [[ $parallel -ge 1 ]]; then
            ,,parallel_output
            ((proc++))
            fd=$((100 + proc))
            eval "exec $fd<> /tmp/,forline-$proc"
            eval "$@ >&$fd 2>&1" &
            eval "exec $fd>&-"
        else
            eval "$@"
        fi
    done <<< "$data"
    if [[ $parallel -ge 1 ]]; then
        parallel=$proc
        ,,parallel_output
    fi
}

