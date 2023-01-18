,cssh () {
    local f_usage="<list of hosts seperated by space>"
    local f_info="Cluster ssh implementation using tmux and ssh"

    local hosts="$@"
    local tmux_session_name="cssh"

    ,,have tmux || { ,error "Install tmux to use this function"; return 52; }
    [[ "${hosts}" ]] || { ,,usage; return; }

    # Find a name for a new session
    local n=0
    while tmux has-session -t "${tmux_session_name}-${n}" &>/dev/null; do
        ((n++))
    done
    local tmux_session="${tmux_session_name}-${n}"

    # Open a new session and split into new panes for each SSH session
    local sshargs=""
    local host
    for host in ${hosts}; do
        if [[ "$host" =~ ^- ]]; then
            sshargs+=" $host"
            continue
        fi
        if ! tmux has-session -t "${tmux_session}" &>/dev/null; then
            tmux new-session -s "${tmux_session}" -d "echo $host;ssh ${sshargs} ${host}"
        else
            tmux split-window -t "${tmux_session}" -d "echo $host;ssh ${sshargs} ${host}"
            # We have to reset the layout after each new pane otherwise the panes
            # quickly become too small to spawn any more
            tmux select-layout -t "${tmux_session}" tiled
        fi
    done

    # Synchronize panes by default
    tmux set-window-option -t "${tmux_session}" synchronize-panes on

    if [[ "${TMUX}" ]]; then
        # We are in a tmux, just switch to the new session
        tmux switch-client -t "${tmux_session}"
    else
        # We are NOT in a tmux, attach to the new session
        tmux attach-session -t "${tmux_session}"
    fi
}

