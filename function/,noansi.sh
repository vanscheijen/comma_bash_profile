,noansi () {
    local f_usage="[file | stdin]"
    local f_info="Shows stdin or optionally a file without ANSI control characters"

    sed "s#\x1B\[[0-9;]*[a-zA-Z]##g" "${1:--}"
}

