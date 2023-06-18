,generate_cert () {
    local f_usage="[CN] [days] [SAN]"
    local f_info="Quickly generate a self-signed certificate, SAN in style DNS:domain.name,IP:ipadres"

    ,,require openssl || return

    local cn=${1:-localhost}
    local days=${2:-3560}
    local san="$3"

    [[ "$3" =~ ^((DNS:[a-z.]+|IP:[0-9.]+),?)*$ ]] || { ,,usage; return; }

    [[ -f "$cn.key" || -f "$cn.crt" ]] && { ,error "Certificate still exists, not overwriting"; return; }

    if [[ "$san" ]]; then
        openssl req -x509 -newkey rsa:4096 -sha256 -days $days -nodes \
            -keyout "$cn.key" -out "$cn.crt" -subj "/CN=$cn" \
            -extensions san -config <(cat <<EOF
[req]
distinguished_name=req
[san]
subjectAltName=$san
EOF
        )
    else
        openssl req -x509 -newkey rsa:4096 -sha256 -days $days -nodes \
            -keyout "$cn.key" -out "$cn.crt" -subj "/CN=$cn"
    fi

    if [[ $? == 0 ]]; then
        ,info "$cn{key,crt} generated"
    else
        ,error "$cn{key,crt} could not be generated"
    fi
}

