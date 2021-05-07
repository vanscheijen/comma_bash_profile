,help () {
    local func usage info

    typeset -f | while read -r line; do
        [[ "$line" =~ ^(,[^,].*)\ \(\)$ ]] && func="${BASH_REMATCH[1]}"
        [[ "$line" =~ ^\ *local\ f_usage=\"(.+)\"\;$ ]] && usage="${BASH_REMATCH[1]}"
        [[ "$line" =~ ^\ *local\ f_info=\"(.+)\"\;$ ]] && info="${BASH_REMATCH[1]}"
        if [[ "$line" =~ ^}$ && "$func" ]]; then
            ,echo "${GREEN}${func} ${BLUE}${usage}"
            [[ "$info" ]] && ,echo "${DIMGRAY}⋯${RESET} ${info}"
            func=""
            usage=""
            info=""
        fi
    done
}

