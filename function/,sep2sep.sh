,sep2sep () {
    local f_usage="[-s] [from] [to] [file]"
    local f_info="Translates separators in [file] (default -) from [from] to [to], by default it is autodetected('a'). Optionally: -s = strip surrounding seperators"

    local strip=0
    if [[ "$1" == "-s" ]]; then
        strip=1
        shift
    fi

    local from="${1:-a}"
    local to="${2:- }"
    local content
    content=$(,ifne cat "${3:--}")

    [[ "${#from}" == 1 && "${#to}" == 1 && "${#content}" -gt 0 ]] || { ,,usage; return; }

    # Autodetect prefers in order: linefeed, pipe, semicolon, comma, space.
    if [[ "$from" == "a" ]]; then
        from=" "
        [[ "$content" =~ ,[^,]+, ]] && from=","
        [[ "$content" =~ \;[^\;]+\; ]] && from=";"
        [[ "$content" =~ \|[^\|]+\| ]] && from="|"
        [[ "$content" =~ $LF[^$LF]+$LF ]] && from="\n"
    fi

    if [[ "$strip" == 1 ]]; then
        tr "$from" "$to" <<< "$content" | sed "s/^[$to]*//;s/[$to]*$//"
    else
        tr "$from" "$to" <<< "$content"
    fi
}

