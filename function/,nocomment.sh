,nocomment () {
    local f_usage="[file]"
    local f_info="Shows stdin or optionally a file without comments"

    grep -Ev '^[ \t]*(#|//|!|"|;)' -- "${1:--}" | strings -n1
}

