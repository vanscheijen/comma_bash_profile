,json_encode () {
    local f_info="Encodes a normal string to a JSON string"

    printf "%s" $1 | python -c "import json,sys; print(json.dumps(sys.stdin.read()))"
}

