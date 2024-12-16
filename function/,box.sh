,box () {
    local f_usage="<text> [-s style] [-t title] [-c color] [-center] [-full] [-w widht] [-h height] [-x column] [-y line]"
    local f_info="Prints <text> within an box with optional <title>. Box style can be 0 for thin-, 1 for thick-, or 2 for double-lined"

    # Styles               0   1   2
    local -a ulcorner=(   "╭" "┏" "╔" )
    local -a urcorner=(   "╮" "┓" "╗" )
    local -a dlcorner=(   "╰" "┗" "╚" )
    local -a drcorner=(   "╯" "┛" "╝" )
    local -a horizontal=( "─" "━" "═" )
    local -a vertical=(   "│" "┃" "║" )
    local -a leftot=(     "┤" "┥" "╡" )
    local -a rightot=(    "├" "┝" "╞" )

    local text style title color stripped line
    local -i x=0 y=1 height=0 width=0 columns full=0 center=0 i j
    columns="$(,,columns)"

    until (($#==0)); do
        case $1 in
            -f|-full) full=1;;
            -m|-center) center=1;;
            -x|-column) x="$2"; shift;;
            -y|-line) y="$2"; shift;;
            -w|-width) width="$2"; shift;;
            -h|-height) height="$2"; shift;;
            -t|-title) title="$2"; shift;;
            -s|-style) style="$2"; shift;;
            -c|-color) color="$2"; shift;;
            -v|-variable) local -n output=$2; shift;; # TODO: Actually output to $output and printf that
            *) text+="$1" ;;
        esac
        shift
    done

    text="$(fmt --width=$columns <<< "$text")"
    stripped="$(printf "$text" | ,noansi)"
    if [[ $width -eq 0 ]]; then
        width="$(awk 'length > max { max = length } END { print max }' <<< "ll${title}rr$LF$stripped")"
        [[ "$full" == 1 || $width -gt $((columns - 2)) ]] && width=$((columns - 2))
    fi
    [[ $center == 1 ]] && y=$(((columns - width) / 2))

    [[ $x -gt 0 ]] && printf "$(CURSOR_POSITION $x $y)"
    printf "$(CURSOR_HORIZONTAL $y)${color}${ulcorner[$style]}"
    for ((i=0; i<width; i++)); do
        printf "${horizontal[$style]}"
    done
    printf "${urcorner[$style]}"
    [[ "$title" ]] && printf "$(CURSOR_HORIZONTAL $((y + 2)))${leftot[$style]}${title}${color}${rightot[$style]}\n" || printf "\n"
    while read -r line; do
        ,echo "$(CURSOR_HORIZONTAL $y)${color}${vertical[$style]}${line}$(CURSOR_HORIZONTAL $((y + width + 1)))${vertical[$style]}"
        ((j++))
    done <<< "$text"
    if [[ $height -gt 0 ]]; then
        for ((i=j; i<height; i++)); do
            ,echo "$(CURSOR_HORIZONTAL $y)${color}${vertical[$style]}$(CURSOR_HORIZONTAL $((y + width + 1)))${vertical[$style]}"
        done
    fi
    printf "$(CURSOR_HORIZONTAL $y)${color}${dlcorner[$style]}"
    for ((i=0; i<width; i++)); do
        printf "${horizontal[$style]}"
    done
    printf "${drcorner[$style]}\n"
}

