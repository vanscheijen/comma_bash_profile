,swapfiles () {
    local f_usage="<first file> <secondary file>"
    local f_info="This command will swap the file names"

    local tmpfile="tmp.$$"

    [[ $# -ne 2 ]] && { ,,usage; return; }
    [[ -e "$1" ]] || { ,error "swap: first file '$1' does not exist"; return 54; }
    [[ -e "$2" ]] || { ,error "swap: second file '$2' does not exist"; return 55; }

    /bin/mv -v "$1" "$tmpfile" && /bin/mv -v "$2" "$1" && /bin/mv -v "$tmpfile" "$2"
}

