,transfervirus () {
    local f_usage="<file>"
    local f_info="Uploads <file> to transfer.sh for file virus scanning purposes"

    [[ "$1" ]] && /usr/bin/curl --progress-bar --upload-file "$1" "https://transfer.sh/$(basename $1)/virustotal" | tee /dev/null
    echo
}

