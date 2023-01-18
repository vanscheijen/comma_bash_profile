,nc () {
    local f_usage="<host> <port>"
    local f_info="Wrapper for nc or ncat, with fallback for bash internal tcp connection"

    ,,have nc && { nc "$@"; return; }
    ,,have ncat && { ncat "$@"; return; }

    local host="${1%:*}"
    local port="${2:-${1#*:}}"

    [[ "$host" && "$port" ]] || { ,,usage; return; }

    local data

    # Connect
    exec 3<>/dev/tcp/$host/$port

    # Send
    ,ifne read -r data
    if [[ "$data" ]]; then
        ,info "Sending: $data"
        printf "$data" >&3
    fi

    # Read (5 second timeout)
    while read -t 5 -r data <&3; do
        echo "$data"
    done

    # Close
    exec 3>&-
}

