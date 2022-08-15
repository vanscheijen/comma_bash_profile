,line () {
    local f_usage="[text | 'gray']"
    local f_info="Fills the entire row with <text> or a special 'gray' line"

    local style="${1:-=}"

    if [[ "$style" == "gray" ]]; then
        for i in {232..255} {254..232}; do
            ,echo -n "$(VGACOLOR ${i})─"
        done
        echo
        return
    fi

    local -i len
    len=$(($(tput cols) / ${#style}))
    printf "%.s$style" $(seq 1 $len)
}

