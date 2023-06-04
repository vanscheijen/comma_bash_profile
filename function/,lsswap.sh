,lsswap () {
    local f_info="List swap usage per process"

    local -i swap
    local -i swap_pid
    local -i swap_total=0
    local -i pid
    local piddir program_name

    for piddir in $(find /proc/ -maxdepth 1 -type d -name '[0-9]*'); do
        swap_pid=0
        pid="${piddir##*/}"
        for swap in $(awk '/Swap/ {print $2}' "$piddir"/{status,smaps} 2>/dev/null); do
            ((swap_pid += swap))
        done
        if ((swap_pid > 0)); then
            program_name="$(ps -p $pid -o comm --no-headers)"
            echo -e "$program_name (pid=$pid) - Swap usage: $swap_pid"
            ((swap_total += swap_pid))
        fi
    done

    ,line
    ,info "Total swap usage: $swap_total"
}

