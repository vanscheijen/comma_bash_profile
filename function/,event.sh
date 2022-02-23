,event () {
    local f_usage="[-g] <event name> [optional count]"
    local f_info="Log an arbitrary event, can be used to track when and how often something occurs."

    local eventname=""
    local count=" 1"
    local show_graphs=0

    local args
    args=`getopt :g $*`
    local argstop=0
    local arg
    for arg in $args; do
        if [[ "$arg" == "--" ]]; then
            argstop=1
        elif [[ "$arg" == "-g" ]]; then
            show_graphs=1
        elif [[ -z "$eventname" ]]; then
            eventname="$arg"
        elif [[ -z "$count" ]]; then
            count=" $arg"
        fi
    done

    [[ "$eventname" ]] || { ,,usage; return; }

    local eventdir="$HOME/.local/share/,event"
    [[ -d "$eventdir" ]] || mkdir -p "$eventdir"
    local eventfile="$eventdir/$eventname"

    if [[ $show_graphs == 1 ]]; then
        ,plot "'$eventfile' using 1:0 with linespoints" "set xdata time;set timefmt \"%s\""
    else
        echo "`date +%s`$count" >> "$eventfile"
    fi
}

