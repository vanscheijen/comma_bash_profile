,onceword () {
    local f_usage="<file>"
    local f_info="Show all words which only occurs once in a file"

    [[ -f "$1" ]] || { ,,usage; return; }

    local -r spacelike="][ \.,;+=\t/\\(){}'\"\`"

    local oncewords
    oncewords=$(
        tr "$spacelike" '\n' < "$1" |
            sed 's/[^-_a-zA-Z0-9]//g' |
                ,lowercase |
                    sort |
                        uniq -c |
                            grep "^ *1 ." |
                                sed 's/^ *1 //' |
                                    tr '\n' '|'
    )

    [[ "$oncewords" ]] || ,debug "No unique words?!"

    grep -E -i --color -C100 "(^|[$spacelike])(${oncewords%|})($|[$spacelike])(${oncewords%|})?" "$1"
}

