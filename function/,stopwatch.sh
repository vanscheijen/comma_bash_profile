,stopwatch () {
    local f_usage="[precision]"
    local f_info="Simple stopwatch, displays elapsed time. Default precision is 0.1"

    local begin
    begin=$(,,now_nano)
    ,info "Stopwatch started, press enter | ctrl-d to stop"
    ,echo "\n"

    until ,ifne; do
        elapsed=$(bc -l <<< "$(,,now_nano) - $begin")
        ,echo "${CURSOR_PREVLINE}Running for $elapsed seconds"
        sleep ${1:-0.1}
    done
    read
    return 0
}

