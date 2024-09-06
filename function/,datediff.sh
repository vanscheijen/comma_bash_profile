,datediff () {
    local f_usage="<from date> [to date] [options]"
    local f_info="Outputs the difference between two dates. Optionally disable(-) or enable(+) (y)ears (w)eeks (d)ays (h)ours (m)inutes (s)econds, (q)uietly or (i)so8601"
    local f_example=",datediff now tomorrow +ih; ,datediff '-10 days 08:00' '25 dec' -q"

    local fromdate
    fromdate="$(date -d "${1:-invalid}" +%s 2>/dev/null)"
    local todate
    todate="$(date -d "${2:-now}" +%s 2>/dev/null)"
    [[ "$fromdate" && "$todate" ]] || { ,,usage; return; }
    local y=1 w=1 d=1 h=1 m=1 s=1 q=0 i=0
    [[ "$3" =~ \+ ]] && y=0 w=0 d=0 h=0 m=0 s=0
    [[ "$3" =~ y ]] && ((y=!y))
    [[ "$3" =~ w ]] && ((w=!w))
    [[ "$3" =~ d ]] && ((d=!d))
    [[ "$3" =~ h ]] && ((h=!h))
    [[ "$3" =~ m ]] && ((m=!m))
    [[ "$3" =~ s ]] && ((s=!s))
    [[ "$3" =~ q ]] && ((q=!q))
    [[ "$3" =~ i ]] && ((i=!i))

    local years weeks days hours minutes seconds
    ((seconds = todate - fromdate))
    [[ $y == 1 ]] && ((years = seconds / 365 / 24 / 60 / 60))
    [[ $y == 1 ]] && ((seconds -= years * 365 * 24 * 60 * 60))
    [[ $w == 1 ]] && ((weeks = seconds / 7 / 24 / 60 / 60))
    [[ $w == 1 ]] && ((seconds -= weeks * 7 * 24 * 60 * 60))
    [[ $d == 1 ]] && ((days = seconds / 24 / 60 / 60))
    [[ $d == 1 ]] && ((seconds -= days * 24 * 60 * 60))
    [[ $h == 1 ]] && ((hours = seconds / 60 / 60))
    [[ $h == 1 ]] && ((seconds -= hours * 60 * 60))
    [[ $m == 1 ]] && ((minutes = seconds / 60))
    [[ $m == 1 ]] && ((seconds -= minutes * 60))
    [[ $s == 1 ]] || ((seconds = 0))

    if [[ "$i" == 1 ]]; then
        local output="P"
        [[ "$years" -ne 0 ]] && output+="${years}Y"
        [[ "$weeks" -ne 0 ]] && output+="${weeks}W"
        [[ "$days" -ne 0 ]] && output+="${days}D"
        output+="T"
        [[ "$hours" -ne 0 ]] && output+="${hours}H"
        [[ "$minutes" -ne 0 ]] && output+="${minutes}M"
        [[ "$seconds" -ne 0 ]] && output+="${seconds}S"
        echo "${output%T}"
    else
        [[ "$q" == 0 ]] && ,echo -n "Between ${DIMBLUE}$(date -d @$fromdate)${RESET} and ${DIMBLUE}$(date -d @$todate)${RESET} are "
        [[ "$years" -ne 0 ]] && ,echo -n "${DIMCYAN}${years}${DIMGREEN}y "
        [[ "$weeks" -ne 0 ]] && ,echo -n "${DIMCYAN}${weeks}${DIMGREEN}w "
        [[ "$days" -ne 0 ]] && ,echo -n "${DIMCYAN}${days}${DIMGREEN}d "
        [[ "$hours" -ne 0 ]] && ,echo -n "${DIMCYAN}${hours}${DIMGREEN}h "
        [[ "$minutes" -ne 0 ]] && ,echo -n "${DIMCYAN}${minutes}${DIMGREEN}m "
        [[ "$seconds" -ne 0 ]] && ,echo -n "${DIMCYAN}${seconds}${DIMGREEN}s"
        echo
    fi
}

