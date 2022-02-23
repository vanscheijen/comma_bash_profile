,c () {
    local f_usage="[formula]"
    local f_info="Calculate simple arithmetic [formula] using awk"
    local f_example=",c '(31.168+12.5)/2.92'; ,c 50**3 + 1"

    [[ "$@" ]] || { ,,usage; return; }
    awk "BEGIN{x=(${@//\*\*/^}); printf(\"%f\t0x%x\n\", x, x)}"
}

