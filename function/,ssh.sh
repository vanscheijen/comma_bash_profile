,ssh () {
    local f_info="Wrapper around ssh which automatically copies this .bash_profile to remote server"

    local host=""
    local ssh_command=""
    local params=""
    local exitcode=0

    local args
    args="$(getopt 1246AaCfgKkMNnqsTtVvXxYb:c:D:e:F:i:L:l:m:O:o:p:R:S:w: $*)"
    local argstop=0
    local arg
    for arg in $args; do
        if [[ "$arg" == "--" ]]; then
            argstop="1"
        elif [[ "$argstop" == "1" ]]; then
            host="$(,lowercase $arg)"
            argstop="2"
        elif [[ "$argstop" == "2" ]]; then
            ssh_command+="${arg} "
        else
            params+="${arg} "
        fi
    done

    [[ "$host" ]] || { /usr/bin/ssh $args; return; }
    [[ "$ssh_command" ]] || ssh_command="exec /bin/bash -l"

    local logfile="$HOME/.ssh/logs/${host#*@}.log"
    touch "$logfile" &>/dev/null || logfile="/dev/null"
    find "$HOME/.ssh" -mindepth 1 -maxdepth 1 -type p -name '*.pipe' -mtime +0 -delete

    if [[ "$host" =~ root@ ]]; then
        /usr/bin/ssh -t $params "$host" "$ssh_command" | tee -a "$logfile"
        exitcode=$PIPESTATUS
    else
        # Do not echo keyboard input to hide early password entry
        stty -echo

        # Only initialize if we don't have a master connection yet
        if ! /usr/bin/ssh -O check "$host" &>/dev/null; then
            local bash_profile_base64
            bash_profile_base64="$(sed '/^# BEGIN EXCLUDE$/,/^# END EXCLUDE$/d;/^ *# /d' "$HOME/.bash_profile" | base64)"
            local cp_command="base64 -d -i <<< '$bash_profile_base64' >| ~/.bash_profile; true"
            # Copy bash profile
            /usr/bin/ssh -C $params "$host" "$cp_command" 2>/dev/null

            if [[ -d "$HOME/.vim/plugins" && "$EUID" != 0 ]]; then
                local vim_profile_base64
                vim_profile_base64="$(cat "$HOME/.vimrc" "$HOME/.vim/plugins/"*.vim | base64)"
                cp_command="base64 -d -i <<< '$vim_profile_base64' >| ~/.vimrc; true"
                # Copy vim profile
                /usr/bin/ssh -C $params "$host" "$cp_command" 2>/dev/null
            fi

            # Copy kitty terminal info if in use
            # ,,have kitty && kitty +kitten ssh "$host" true 2>/dev/null
        fi

        # Use a named pipe for logging, this enables kitty remote to work
        local pipefile
        pipefile="$(mktemp -u ${HOME}/.ssh/${host}.XXXXX.pipe)"
        mkfifo "$pipefile"
        exec 3>&1 4>&2 &>/dev/null
        tee -a "$logfile" < "$pipefile" >&3 &
        local teepid=$!
        exec >"$pipefile" 2>&1
        /usr/bin/ssh -t $params "$host" "$ssh_command"
        exitcode=$?
        exec 1>&3 3>&- 2>&4 4>&-
        wait $teepid &>/dev/null
        rm "$pipefile"
    fi

    return $exitcode
}

