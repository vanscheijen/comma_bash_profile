,transfer () {
    [[ "$1" ]] && /usr/bin/curl --progress-bar --upload-file "$1" "https://transfer.sh/$(basename $1)" | tee /dev/null
    echo
}

