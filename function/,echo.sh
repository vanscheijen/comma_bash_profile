,echo () {
    local f_usage="[-n] <string>"
    local f_info="Echo <string> with correct ANSI interpretation. Use '-n' to not output the trailing newline"

    if [[ "$1" == "-n" ]]; then
        printf "${RESET}${@:2}${RESET}"
    else
        printf "${RESET}$@${RESET}\n"
    fi
}

