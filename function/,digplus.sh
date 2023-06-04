,digplus () {
    local f_usage="[-s <nameserver>] [-x] [--] <domain> [type]"
    local f_info="Resolve a domain plus-ultra using bind dig. -x = extended view"

    local EXTENDED=""
    local NS=""
    while :; do
        case "$1" in
            --) shift; break ;;
            -x) EXTENDED=y; shift ;;
            -s) NS="$2"; shift 2 ;;
            *) break ;;
        esac
    done
    local DOM="$1"; shift
    local TYPE="${1:-any}"

    [[ "$DOM" ]] || { ,,usage; return; }

    [[ "$NS" ]] || NS="$(dig "$DOM" SOA +short | awk '{print $1}')"

    echo "$(dig "@$NS" "$DOM" "$TYPE" +dnssec +nocmd +noall +answer)"
    if [[ "$EXTENDED" ]]; then
        local sub
        for sub in www mail mx smtp pop imap blog en ftp ssh login vpn '*'; do
            echo "$(dig "@$NS" "$sub.$DOM" "$TYPE" +nocmd +noall +answer)"
        done
    fi
}

