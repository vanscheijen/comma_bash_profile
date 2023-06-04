,encrypt () {
    local f_usage="<password> [string | file | stdin]"
    local f_info="Encrypts given input with aes-256-cbc and encodes it with base64 to stdout"

    ,,require openssl || return

    local password="$1"
    local data="${@:2}"
    [[ -s "$data" ]] && data="$(< "$data")" || data="$(,ifne cat)" || data="${@:2}"

    openssl enc -e --aes-256-cbc -base64 -nosalt -k "$password" <<< "$data" 2>/dev/null
}

