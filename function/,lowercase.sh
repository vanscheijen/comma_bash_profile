,lowercase () {
    local f_usage="[string]"
    local f_info="Lowercase [string] or else standard input"

    if [[ "$@" ]]; then
        if ((BASH_VERSINFO[0] < 4)); then
            tr '[:upper:]' '[:lower:]' <<< "$@"
        else
            echo "${@,,}"
        fi
    else
        tr '[:upper:]' '[:lower:]'
    fi
}

