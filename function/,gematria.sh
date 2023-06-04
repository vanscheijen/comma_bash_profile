,gematria () {
    local f_usage="<word>"
    local f_info="Show the sum of all individual letters of <word> where a=1,b=2,...,z=26"

    local word
    local -i i value

    local -r spacelike="][ \.,;+=\t/\\(){}'\"\`"

    tr "$spacelike" '\n' <<< "$@" |
        sed 's/[^a-zA-Z]//g' |
            ,lowercase | while read word; do
        value=0
        for ((i=0; i < ${#word}; i++)); do
            value+="$(printf "%d-96" "'${word:i:1}")"
        done
        echo "$word = $value"
    done
}

