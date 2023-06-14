,json_encode () {
    local f_usage="<string | file | stdin>"
    local f_info="Encodes a normal string to a JSON string"

    ,,require python || return

    local data="$@"
    [[ -s "$data"  ]] && data="$(< "$data")" || [[ "$data"  ]] || data="$(,ifne cat)" || { ,,usage; return; }

    printf "%s" "$data" | python -c "import json,sys; print(json.dumps(sys.stdin.read()))"
}

