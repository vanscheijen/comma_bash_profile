,echo () {
    if [[ "$1" == "-n" ]]; then
        printf "${RESET}${@:2}${RESET}"
    else
        printf "${RESET}$@${RESET}\n"
    fi
}

