,sep2sep () {
    local f_usage="[-s] [from] [to] <string | file | stdin>"
    local f_info="Translates separators in input from [from] (default autodetection 'a') to [to] (default space ' '). Optionally: -s = strip surrounding seperators"

    local sss=0
    if [[ "$1" == "-s" ]]; then
        sss=1
        shift
    fi

    local from="${1:-a}"
    local to="${2:- }"
    [[ "$to" == "a" || "$to" == "s" ]] && to=" "
    [[ "$to" == "n" || "$to" == "\n" ]] && to=$LF
    local data="${@:3}"
    [[ -s "$data"  ]] && data="$(< "$data")" || [[ "$data"  ]] || data="$(,ifne cat)" || { ,,usage; return; }

    [[ "${#from}" == 1 && "${#to}" == 1 && "${#data}" -gt 0 ]] || { ,,usage; return; }

    # Autodetect prefers in order: linefeed, pipe, semicolon, comma, tab, space.
    if [[ "$from" == "a" ]]; then
        from=" "
        [[ "$data" =~ $HT[^$HT]+$HT ]] && from="\t"
        [[ "$data" =~ ,[^,]+, ]] && from=","
        [[ "$data" =~ \;[^\;]+\; ]] && from=";"
        [[ "$data" =~ \|[^\|]+\| ]] && from="|"
        [[ "$data" =~ $LF[^$LF]+$LF ]] && from="\n"
    fi

    if [[ "$sss" == 1 ]]; then
        tr "$from" "$to" <<< "$data" | sed "s/^[${to@Q}]*//;s/[${to@Q}]*$//"
    else
        tr "$from" "$to" <<< "$data"
    fi
}

