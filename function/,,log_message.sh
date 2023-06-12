,,log_message () {
    local level="${FUNCNAME[1]#,}"

    local debug="$PURPLE"
    local info="$CYAN"
    local ok="$GREEN"
    local notice="$BLUE"
    local warning="$YELLOW"
    local error="$RED"

    ,echo "${DIMGRAY}[${!level}$(,uppercase $level)${DIMGRAY}]${RESET} $@" 1>&2
}

# Generate logging functions for all loglevels
for f in debug info ok notice warning error; do
    eval ",${f} () { local f_usage=\"<string>\"; local f_info=\"Log <string> as a $f message\"; ,,log_message \"\$@\"; }"
done
unset -v f

