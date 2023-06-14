,setx () {
    local f_usage="[command]"
    local f_info="Sets PS4 and toggles bash debug mode, optionally only debugging [command]"

    export PS4='+\033[0m(\033[31m${BASH_SOURCE}:${LINENO}\033[0m): \033[32m${FUNCNAME[0]:+${FUNCNAME[0]}(): }\033[0m'

    if [[ "$@" ]]; then
        set -x
        eval "$@"
        set +x
    else
        [[ "$-" =~ x ]] && set +x || set -x
    fi
}

