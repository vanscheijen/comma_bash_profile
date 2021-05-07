## Trap handling

,,trap () {
    ,echo -n "${CURSOR_NEXTLINE}"
    ,box "`,debug "Trapped $@"`"
    exit 50
}

# trap ",,trap SIGINT" SIGINT # Ctrl-c
trap ",,trap SIGQUIT" SIGQUIT # Ctrl-\
trap ",,trap SIGTERM" SIGTERM # kill
trap ",,trap SIGHUP" SIGHUP # kill -HUP

