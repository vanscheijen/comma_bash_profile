,help () {
    local f_usage="<string>"
    local f_info="Lists all comma commands by default. Optional search for <string>"

    local func usage info
    local find="${1##,}"

    typeset -f | while read -r line; do
        [[ "$line" =~ ^(,${find}.*)\ \(\)$ ]] && func="${BASH_REMATCH[1]}"
        [[ "$line" =~ ^\ *local\ f_usage=\"(.+)\"\;$ ]] && usage="${BASH_REMATCH[1]}"
        [[ "$line" =~ ^\ *local\ f_info=\"(.+)\"\;$ ]] && info="${BASH_REMATCH[1]}"
        if [[ "$line" =~ ^}$ ]]; then
            if [[ "$func" && ! "$func" =~ ^,, ]]; then
                ,echo "${GREEN}${func} ${BLUE}${usage}"
                [[ "$info" ]] && ,echo "${DIMGRAY}⋯${RESET} ${info}"
            fi
            func=""
            usage=""
            info=""
        fi
    done

    echo

    alias -p | grep "^alias ," | while read -r line; do
        [[ "$line" =~ ^alias\ (,${find}.*)=\'(.*)\'$ ]] && ,echo "${GREEN}${BASH_REMATCH[1]} ${BLUE}${BASH_REMATCH[2]//%/%%}"
    done
}

