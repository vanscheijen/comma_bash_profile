,c () {
    local f_usage="[formula]"
    local f_info="Calculate simple arithmetic [formula] using awk"

    local formula="${@:-0}"
    awk "BEGIN{x=(${formula//\*\*/^}); printf(\"%f\t0x%x\t'%c'\n\", x, x, x)}"
}

