,encrypt () {
    local f_usage="<password> [text | file]"
    local f_info="Encrypt a file or text with aes-256-cbc and encode with base64"

    ,,require openssl || return

    local password="$1"
    local data="$2"
    [[ -s "$data" ]] && data=$(< "$data")

    openssl enc -e --aes-256-cbc -base64 -nosalt -k "$password" <<< "$data" 2>/dev/null
}

