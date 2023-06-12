,box () {
    local f_usage="<text> [box style (0/1/2)] [title]"
    local f_info="Prints <text> within a ascii box. Box style can be 1 for thin-, 2 for thick-, or 3 for double-lined"

    # Styles               0   1   2
    local -a ulcorner=(   "╭" "┏" "╔" )
    local -a urcorner=(   "╮" "┓" "╗" )
    local -a dlcorner=(   "╰" "┗" "╚" )
    local -a drcorner=(   "╯" "┛" "╝" )
    local -a horizontal=( "─" "━" "═" )
    local -a vertical=(   "│" "┃" "║" )
    local -a leftot=(     "┤" "┥" "╡" )
    local -a rightot=(    "├" "┝" "╞" )

    local -i style="$2"
    local title="$3"
    local columns text stripped width
    columns="$(stty size)"
    columns="${columns##* }"
    text="$(fmt --width=$columns <<< "$1")"
    stripped="$(printf "$text" | sed "s#\x1B\[[0-9;]*[a-zA-Z]##g")"
    width="$(awk 'length > m { m = length; a = $0 } END { print a }' <<< "ll${title}rr$LF$stripped")"

    printf "${ulcorner[$style]}"
    local -i i
    for ((i=0; i<${#width}; i++)); do
        printf "${horizontal[$style]}"
    done
    printf "${urcorner[$style]}"
    [[ "$title" ]] && printf "$(CURSOR_HORIZONTAL 3)${leftot[$style]}${title}${rightot[$style]}\n" || printf "\n"
    local line
    while read -r line; do
        ,echo "${vertical[$style]}${line}$(CURSOR_HORIZONTAL $((${#width} + 2)))${vertical[$style]}"
    done <<< "$text"
    printf "${dlcorner[$style]}"
    for ((i=0; i<${#width}; i++)); do
        printf "${horizontal[$style]}"
    done
    echo "${drcorner[$style]}"
}

