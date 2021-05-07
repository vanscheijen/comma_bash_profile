,url_decode () {
    local f_info="Decodes an URL encoded string to a normal string"

    local url_encoded="${1//+/ }"
    printf "%b" "${url_encoded//%/\\x}"
}

