,decrypt () {
    local f_usage="<password> [text | file]"
    local f_info="Decode a file or text with base64 and decrypt using aes-256-cbc"

    ,,require openssl || return

    local password="$1"
    local data="$2"
    [[ -s "$data" ]] && data=`< "$data"`

    openssl enc -d --aes-256-cbc -base64 -nosalt -k "$password" <<< "$data" 2>/dev/null
}

