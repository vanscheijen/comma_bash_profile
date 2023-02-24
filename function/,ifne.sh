,ifne () {
    local f_usage="[command]"
    local f_info="IF Not Empty, if stdin is not empty execute [command]"

    [[ -t 0 ]] && return 53
    eval "$@"
}

