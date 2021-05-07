,bash_profiler () {
    local f_usage="<bash file or function> [arguments]"
    local f_info="Profile bash using set -x, shows line count and time (sub)totals"

    ,,require_bash4 || return

    local stderr
    stderr=`mktemp`
    local exitcode=0

    # NOTE: The first character of the expanded value of PS4 is replicated multiple times, as necessary, to indicate multiple levels of indirection.
    if [[ -f "$1" ]]; then
        exec 9>> "$stderr"
        if ((BASH_VERSINFO[0] >= 5)); then
            BASH_XTRACEFD="9" PS4=" \013\${EPOCHREALTIME}\014\${BASH_SOURCE[0]}\014\${FUNCNAME[0]:- }\014\${LINENO}\014\${BASH_COMMAND}\014" /bin/bash -x "$@"
        else
            BASH_XTRACEFD="9" PS4=" \013\$(date +%s.%N)\014\${BASH_SOURCE[0]}\014\${FUNCNAME[0]:- }\014\${LINENO}\014\${BASH_COMMAND}\014" /bin/bash -x "$@"
        fi
        exitcode=$?
    elif typeset -f "$1" &>/dev/null; then
        (
            BASH_XTRACEFD="9"
            PS4=" \013\$(,,now_nano)\014\${BASH_SOURCE[0]}\014\${FUNCNAME[0]:- }\014\${LINENO}\014\${BASH_COMMAND}\014"
            set -x
            "$@"
        ) 9>> "$stderr"
        exitcode=$?
    else
        /bin/rm -f "$stderr"
        ,error "Argument '$1' is neither a bash file nor function"
        return 59
    fi
    local last_timestamp
    last_timestamp=`,,now_nano`

    # Workaround to support multiline bash commands
    local tmpfile
    tmpfile=`mktemp`
    tr '\n' '\r' < "$stderr" | sed 's/ *\v/\n/g' | tail -n +2 >| "$tmpfile"
    /bin/mv -f "$tmpfile" "$stderr"

    local -r SEP=$'\f'
    local -A linetime
    local -A linecount
    local -a lineorder
    local -A lineouts
    local -A linecommand
    local timestamp bash_source bash_function bash_line bash_command parsed_command lineid prev_timestamp prev_lineid longest_function_name
    while IFS="$SEP" read -r timestamp bash_source bash_function bash_line bash_command parsed_command; do
        if [[ ! "$timestamp" =~ ^\ *[0-9]+\.[0-9]+$ ]]; then
            ,debug "PS4 unexpected output: ${timestamp@Q} | ${bash_source@Q}| ${bash_function@Q} | ${bash_line@Q} | ${bash_command@Q} | ${parsed_command@Q}"
            continue
        fi

        # Keep track of longest function name to minimze later column width
        [[ "${#bash_function}" -gt ${longest_function_name:-0} ]] && longest_function_name=${#bash_function}

        # Encode source+function+lineno as associative array id
        lineid=`base64 <<< "$bash_source$SEP$bash_function$SEP$bash_line" | tr -d '\n'`

        # Keep track of the order by which lines are execued
        [[ "${linecount["$lineid"]}" ]] || lineorder+=("$lineid")
        linecommand["$lineid"]="$bash_command"

        # The timestamp of PS4 is of the start of execution, so we can only know running time for each previous line
        if [[ "$prev_timestamp" ]]; then
            linetime["$prev_lineid"]=`bc -l <<< "${linetime["$prev_lineid"]:-0} + ($timestamp - $prev_timestamp)"`
        else
            local first_timestamp="$timestamp"
        fi

        ((linecount["$lineid"]++))
        lineouts["$lineid"]="${lineouts["$lineid"]}
${parsed_command//$'\r'/ }"

        prev_timestamp="$timestamp"
        prev_lineid="$lineid"
    done < "$stderr"
    # cat "$stderr"

    # Calculate time for last command
    linetime["$prev_lineid"]=`bc -l <<< "${linetime["$prev_lineid"]:-0} + ($last_timestamp - $prev_timestamp)"`

    local -r decimals=4 # for count and line number
    ,line

    for lineid in "${lineorder[@]}"; do
        lineinfo=`base64 -d <<< "$lineid"`
        IFS="$SEP" read -r bash_source bash_function bash_line <<< "$lineinfo"

        if typeset -f "$bash_function" &>/dev/null; then
            bash_command="${linecommand["$lineid"]}"
        else
            bash_command=`sed -n "s/^[ \\t]*//;${bash_line}p;$((bash_line + 1))q" "$bash_source"`
        fi

        printf "%011.6f    (${CYAN}%${decimals}d${RESET}) %0${decimals}d | % ${longest_function_name}s | %s\n" "${linetime["$lineid"]}" "${linecount["$lineid"]}" "$bash_line" "$bash_function" "$bash_command"

        echo "${lineouts["$lineid"]#$LF}" | sort | uniq -c | sort -rn | while read -r count line; do
            printf "% 11s    (%${decimals}d) % ${decimals}s | % ${longest_function_name}s | %s\n" "" "$count" "" "" "$line"
        done
    done

    ,line
    echo -e "
    total time\t: `bc -l <<< "$last_timestamp - $first_timestamp"`
    exited with\t: $exitcode"

    /bin/rm -f "$stderr"
}

