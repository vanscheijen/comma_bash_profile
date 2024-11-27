,,usage () {
    ,notice "Usage: ${GREEN}${FUNCNAME[1]} ${BLUE}${f_usage//\\/\\\\}"
    [[ "$f_info" ]] && ,echo "\n${DIMGRAY}⋯${RESET} ${f_info}\n"
    [[ "$f_example" ]] && ,box "${f_example//;/$LF}" -s 1 -t "Example(s)"
    return 51
}

