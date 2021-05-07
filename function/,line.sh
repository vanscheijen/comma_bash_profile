,line () {
    local style="${1:-=}"
    local -i len
    len=$(($(tput cols) / ${#style}))
    printf "%.s$style" $(seq 1 $len)
}

