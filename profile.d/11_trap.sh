# Trap handling

,,trap () {
    # Example: Prevent signal when already trapped by ignoring them from now on.
    # trap "" SIGQUIT
    # trap "" SIGTERM
    # trap "" SIGHUP

    ,echo -n "${CURSOR_NEXTLINE}"
    ,box "$(,debug "Trapped $@")"
    exit 50
}

# trap ",,trap SIGINT" SIGINT # Ctrl-c
trap ",,trap SIGQUIT" SIGQUIT # Ctrl-\
trap ",,trap SIGTERM" SIGTERM # kill
trap ",,trap SIGHUP" SIGHUP # kill -HUP

