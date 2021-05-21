,nocomment () {
    grep -Ev '^[ \t]*(#|//|!|"|;)' "${1:--}" | strings -n1
}

