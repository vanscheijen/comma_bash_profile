,lsswap () {
    local -i swap
    local -i swap_pid
    local -i swap_total
    local -i pid
    local piddir program_name

    for piddir in $(find /proc/ -maxdepth 1 -type d -name '[0-9]*'); do
        swap_pid=0
        pid=`cut -d / -f 3 <<< "$piddir"`
        program_name=`ps -p $pid -o comm --no-headers`
        for swap in $(grep Swap "$piddir"/{status,smaps} 2>/dev/null | awk '{print $2}'); do
            ((swap_pid += swap))
        done
        if ((swap_pid > 0)); then
            echo -e "$program_name (pid=$pid) - Swap usage: $swap_pid"
            ((swap_total += swap_pid))
        fi
    done

    ,line
    ,info "Total swap usage: $swap_total"
}

