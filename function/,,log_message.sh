,,log_message () {
    local level="${FUNCNAME[1]#,}"

    local debug="$PURPLE"
    local info="$CYAN"
    local ok="$GREEN"
    local notice="$BLUE"
    local warning="$YELLOW"
    local error="$RED"

    ,echo "${DIMGRAY}[${!level}`,uppercase $level`${DIMGRAY}]${RESET} $@"
}

# Generate logging functions for all loglevels
for f in debug info ok notice warning error; do
    eval ",${f} () { ,,log_message \"\$@\"; }"
done
unset -v f

