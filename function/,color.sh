,color () {
    local f_usage="[ 'b' | 'd' | 't' | 'a' | 'p' | <hexcode> ]"
    local f_info="Make pts background a certain color for ease of differentation when working with multiple hosts"

    local color="${1:-b}"

    [[ "$color" == "b" ]] && color="000000"
    [[ "$color" == "d" ]] && color="003000"
    [[ "$color" == "t" ]] && color="000030"
    [[ "$color" == "a" ]] && color="300030"
    [[ "$color" == "p" ]] && color="300000"

    TERMRGBCOLOR $color >| $(tty)
}

