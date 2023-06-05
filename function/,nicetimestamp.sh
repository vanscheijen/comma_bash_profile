,nicetimestamp () {
    local f_usage="[file]"
    local f_info="Converts any unix timestamp in all lines given via stdin or in <file>"

    ,,require perl || return

    cat "${1:--}" | perl -pe 's/(\d+)/localtime($1)/e'
}

