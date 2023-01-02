,dice () {
    local f_usage="[amount]d<faces>[*multiplier][+addition]"
    local f_info="Roll dice in standard RPG dice notation format"
    local f_example=",dice 2d8*3+6 # roll three dices with 8 faces, multiply by 3, and add 6"

    local arg
    for arg; do
        if [[ "$arg" =~ ^([1-9][0-9]*)?[dD]([1-9][0-9]*)(\*[1-9][0-9]*)?(\+[1-9][0-9]*)?$ ]]; then
            local dice=${BASH_REMATCH[1]:-1}
            local faces=${BASH_REMATCH[2]}
            local multiplier=${BASH_REMATCH[3]#\*}
            local addition=${BASH_REMATCH[4]#+}
            local total=0
            local subtotal=0
            local throws=""
            local throw
            local color
            for ((d=1; d<=$dice; d++)); do
                throw=$((RANDOM % faces + 1))
                color=""
                ((total += throw))
                [[ $throw -eq 1 ]] && color="$RED"
                [[ $throw -eq $faces ]] && color="$GREEN"
                throws+="$color$throw$RESET + "
            done
            if [[ "$multiplier" ]]; then
                subtotal=$((total = total * multiplier))
                throws="${throws% + } * $multiplier + "
            fi
            if [[ "$addition" ]]; then
                ((total += addition))
                throws+="$addition + "
            fi
            ,echo "${BASH_REMATCH[0]}: ${throws% + } = $BLUE$total"
        fi
    done
}

