,grep () {
    local f_usage="[-f | -q | -l] [-rs] <patterns...> [file | dir]"
    local f_info="Comma grep enhances normal grep with code-block contextual patterns to match as an AND filter. Options: only show (-f)ile names or (-q)uiet. (-l)ines only"

    [[ -z "$1" ]] && { ,,usage; return; }

    local exitcode=1 verbosity=3 grepcolor=1

    local arg first target awkmatch grepmatch linesmatch
    for arg; do
        if [[ "$arg" == "-l" ]]; then
            verbosity=2
        elif [[ "$arg" == "-f" ]]; then
            verbosity=1
        elif [[ "$arg" == "-q" ]]; then
            verbosity=0
        else
            if [[ "$first" ]]; then
                if [[ -z "$target" && -f "$arg" || -d "$arg" ]]; then
                    target="$arg"
                    continue
                fi
            else
                first="$arg"
            fi

            arg="${arg//\//\\/}"
            awkmatch+="match(tolower(\$0), /${arg,,}/) && "

            grepmatch+="GREP_COLORS='mt=38;5;$((grepcolor++))' \grep -E -i -C99 --color=always -- '"${arg//\'/\'\\\'\'}"' | "

            linesmatch+="$arg|"
        fi
    done
    awkmatch="${awkmatch% && }"
    grepmatch="${grepmatch% | }"
    linesmatch="${linesmatch%|}"

    local filelist f block greps color output line
    filelist=$(\grep -E -i -rIHm1 --exclude-dir=.git --exclude-dir=.env -- "$first" "${target:-.}" 2>/dev/null | awk -F':' '!/^.*\.swp:/ {print $1}')
    while read f; do
        block=""
        grep -qm1 ' () {$' "$f" && block=$(awk -v RS='\n}' "$awkmatch { print \$0 \"\\n}\" }" "$f")
        [[ "$block" ]] || block=$(awk -v RS='\n\n' "$awkmatch { print \$0 \"\\n\\n\" }" "$f")
        [[ "$block" ]] || continue

        exitcode=0
        [[ $verbosity == 0 ]] && break

        greps="echo \"\$block\" | sed '/./,\$!d' | $grepmatch"
        if [[ $verbosity == 1 ]]; then
            echo "$f"
        elif [[ $verbosity == 2 ]]; then
            output=`eval ${greps} | \grep -E "$linesmatch"`
            while read line; do
                ,echo "${DIMGREEN}$f${RESET}: $line"
            done <<< "$output"
        elif [[ $verbosity == 3 ]]; then
            ,echo "${CYAN}${f}\n"
            eval ${greps}
            ,line gray
        fi
    done <<< "$filelist"

    return $exitcode
}

