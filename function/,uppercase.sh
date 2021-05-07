,uppercase () {
    local f_usage="[string]"
    local f_info="Uppercase [string] or else standard input"

    if [[ "$@" ]]; then
        if ((BASH_VERSINFO[0] < 4)); then
            tr '[:lower:]' '[:upper:]' <<< "$@"
        else
            echo "${@^^}"
        fi
    else
        tr '[:lower:]' '[:upper:]'
    fi
}

