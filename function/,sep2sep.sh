,sep2sep () {
    local f_usage="[-s] [from] [to] [file]"
    local f_info="Translates separators in [file] (default stdin '-') from [from] (default autodetection 'a') to [to] (default space ' '). Optionally: -s = strip surrounding seperators"

    local strip=0
    if [[ "$1" == "-s" ]]; then
        strip=1
        shift
    fi

    local from="${1:-a}"
    local to="${2:- }"
    [[ "$to" == "a" ]] && to=" "
    [[ "$to" == "n" || "$to" == "\n" ]] && to=$LF
    local content
    if [[ "$3" ]]; then
        [[ -s "$3" ]] || { ,error "'$3' is not a file"; return 65; }
    else
        ,ifne || { ,,usage; return; }
    fi
    content=$(cat "${3:--}")

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

