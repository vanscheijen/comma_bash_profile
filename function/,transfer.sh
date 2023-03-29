,transfer () {
    local f_usage="<file>"
    local f_info="Uploads <file> to transfer.sh for file sharing purposes"

    ,,require curl || return

    [[ "$1" ]] && curl --progress-bar --upload-file "$1" "https://transfer.sh/$(basename $1)" | tee /dev/null
    echo
}

