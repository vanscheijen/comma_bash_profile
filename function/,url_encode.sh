,url_encode () {
    local f_usage="<string | file | stdin>"
    local f_info="Encodes a normal string to an URL encoded string"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    local -i i
    for ((i=0; i<${#data}; i++)); do
        local c="${data:i:1}"
        case $c in
            [a-zA-Z0-9.~_-])
                printf "$c"
                ;;
            *)
                printf "%%%x" $(printf "%d" "'$c")
                ;;
        esac
    done
    echo
}

