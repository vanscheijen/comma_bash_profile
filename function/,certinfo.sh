,certinfo () {
    local f_usage="<x509 certificate filename>"
    local f_info="Show detailed certificate information using openssl"

    ,,require openssl || return

    [[ -s "$1" ]] || { ,,usage; return; }

    local -r bc="-----BEGIN CERTIFICATE-----"
    local -r ec="-----END CERTIFICATE-----"
    local certs cert
    certs="$(awk "/$bc/,/$ec/" "$1")"

    local line
    while read -r line; do
        cert+="$line
"
        if [[ "$line" =~ $ec ]]; then
            openssl x509 -text -noout <<< "$cert"
            cert=""
        fi
    done <<< "$certs"
}

