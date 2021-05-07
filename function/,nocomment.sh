,nocomment () {
    grep -Pv "^\w*(#|//)" "${1:--}" | strings -n1
}

