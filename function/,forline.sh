,forline () {
    local f_usage="[-p] [file | stdin] <command>"
    local f_info="Loops through each line(as \$line with \$lineno) in [file | stdin] and executes <command> (defaults to echo \\\$lineno: \\\$line). Optionally in batched parallel with [-p]"

    local -i parallel=0
    if [[ "$1" == "-p" ]]; then
        local -i proc=0 fd
        local tmpdir
        tmpdir="$(mktemp -d)"
        ,,have nproc && parallel=$(($(nproc) * 2)) || parallel=8
        shift
    fi

    local data="$1"
    [[ -s "$data" && ! -x "$data" ]] && { data="$(< "$data")"; shift; } || data="$(,ifne cat)" || { ,,usage; return; }

    [[ -n "$@" ]] || set 'echo "$lineno: $line"'
    [[ "$@" =~ \$line ]] || set "$@" '"$line"'

    ,,parallel_output() {
        if [[ $proc -ge $parallel ]]; then
            wait
            cat $tmpdir/*
            rm -f $tmpdir/*
            proc=0
        fi
    }

    local line lineno=0
    while IFS= read -r line; do
        ((lineno++))
        if [[ $parallel -ge 1 ]]; then
            ,,parallel_output
            ((proc++))
            fd=$((100 + proc))
            eval "exec $fd<> $tmpdir/$(printf "%04d" $proc)"
            eval "$@ >&$fd 2>&1" &
            eval "exec $fd>&-"
        else
            eval "$@"
        fi
    done <<< "$data"

    if [[ $parallel -ge 1 ]]; then
        parallel=$proc
        ,,parallel_output
        rm -rf "$tmpdir"
    fi
}

