,ocsp_check () {
    local f_usage="[certificate file]"
    local f_info="Check ocsp status using openssl"

    ,,require curl || return
    ,,require openssl || return
    [[ -s "$1" ]] || { ,,usage; return; }

    local ocsp_uri
    local ts
    local truststore
    local tmpfile

    ca_issuer=`openssl x509 -noout -text -in "$1" | awk '/^[ \t]+CA Issuers[ \t]+-[ \t]+URI:/ { print gensub(/^.*URI:(.*)$/, "\\\1", "g", $0); }'`
    ocsp_uri=`openssl x509 -noout -ocsp_uri -in "$1"`
    [[ "$ca_issuer" ]] || { ,warning "`basename $1` has no CA Issuers URI"; return 1; }
    [[ "$ocsp_uri" ]] || { ,warning "`basename $1` has no OCSP URI"; return 2; }

    tmpfile=$(mktemp)
    curl --fail "$ca_issuer" --output "$tmpfile" || { ,error "Could not retrieve $ca_issuer"; return 3; }
    openssl x509 -inform DER -outform PEM -in "$tmpfile" -out "${tmpfile}.pem" || { ,warning "Could not convert DER to PEM"; }
    openssl ocsp -issuer "${tmpfile}.pem" -cert "$1" -text -url "$ocsp_uri"
    rm -f "$tmpfile" "${tmpfile}.pem"
}

