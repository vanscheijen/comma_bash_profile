,,require_bash4 () {
    if ((BASH_VERSINFO[0] < 4)); then
        ,error "${FUNCNAME[1]} requires at least bash-4.0"
        return 60
    fi
}

