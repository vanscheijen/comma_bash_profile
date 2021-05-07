,,require () {
    if ! ,have "$1"; then
        ,error "${FUNCNAME[1]} requires $1 to be installed"
        return 60
    fi
}

