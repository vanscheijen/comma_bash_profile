,decode () {
    local f_usage="<string | file | stdin>"
    local f_info="Decodes input automatically, detects binary|hexidecimal|base64"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || data="$(,ifne cat)" || data="$@"

    if [[ "$data" =~ ^[01\ ]+$ ]]; then
        local bindata="${data// /}"
        while read -n8 -r byte; do
            [[ "$byte" ]] || continue
            printf "\\$(echo "obase=8; ibase=2; $byte" | bc)"
        done <<< "$bindata"
    elif [[ "$data" =~ ^[a-fA-F0-9x\ ]+$ ]]; then
        local hexdata="${data// /}"
        hexdata="${hexdata//0x/}"
        for ((i=0; i < ${#hexdata}; i += 2)); do
            printf "%b" "\x${hexdata:$i:2}"
        done
    elif [[ "$data" =~ ^[a-Z0-9+/\ \n]+={0,2}$ ]]; then
        base64 -id <<< "$data"
    else
        ,warning "Could not detect encoding"
    fi
}

