,repeat () {
    local f_usage="<count> <command>"
    local f_info="This command will repeat an eval of <command> for <count> times, you can read the current counter as \\\$i"

    local -i count="$1"
    ((count > 0)) || { ,,usage; return; }
    shift

    local -i i
    for ((i=0; i < count; i++)); do
        eval "$@"
    done
}

