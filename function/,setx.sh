,setx () {
    export PS4='+\033[0m(\033[31m${BASH_SOURCE}:${LINENO}\033[0m): \033[32m${FUNCNAME[0]:+${FUNCNAME[0]}(): }\033[0m'
    [[ "$-" =~ x ]] && set +x || set -x
}

