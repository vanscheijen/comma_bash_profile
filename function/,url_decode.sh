,url_decode () {
    local f_usage="<string | file | stdin>"
    local f_info="Decodes an URL encoded string to a normal string"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    data="${data//+/ }"
    printf "%b" "${data//%/\\x}\n"
}

