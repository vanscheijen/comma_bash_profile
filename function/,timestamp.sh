,timestamp () {
    local f_info="Add timestamp to stream"

    while IFS='' read -s -r line; do
        echo "`,,now` $line"
    done
}

