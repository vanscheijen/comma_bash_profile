,decrypt () {
    local f_usage="<password> <string | file | stdin>"
    local f_info="Decodes given input with base64 and then decrypts using aes-256-cbc to stdout"

    ,,require openssl || return

    local password="$1"
    local data="${@:2}"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    openssl enc -d --aes-256-cbc -base64 -nosalt -k "$password" <<< "$data" 2>/dev/null
}

