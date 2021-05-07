,url_encode () {
    local f_info="Encodes a normal string to an URL encoded string"

    local -i i
    for ((i=0; i < ${#1}; i++)); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-])
                printf "$c"
                ;;
            *)
                printf "%%%x" `printf "%d" "'$c"`
                ;;
        esac
    done
}

