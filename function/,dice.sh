,dice () {
    local f_usage="<dice>"
    local f_info="Shows stdin or optionally a file without comments"
    local f_example=",dice 3d20 # rolls three dices with 20 faces"

    local arg
    for arg; do
        if [[ "$arg" =~ ^([1-9][0-9]*)[dD]([1-9][0-9]*)$ ]]; then
            local dice=${BASH_REMATCH[1]}
            local faces=${BASH_REMATCH[2]}
            local total=0
            local throws=""
            local throw
            for ((d=1; d<=$dice; d++)); do
                throw=$((RANDOM % faces + 1))
                ((total += throw))
                throws+="$throw + "
            done
            echo "${BASH_REMATCH[0]}: ${throws% + } = $total"
        fi
    done
}

