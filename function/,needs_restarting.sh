,needs_restarting () {
    local f_info="List all running processes that are deleted."

    echo "PID    EXE"
    local pp
    for pp in /proc/[0-9]*; do
        [[ -d "$pp" ]] || continue
        exefile="$pp/exe"
        [[ -f "$exefile" ]] || continue
        pid="${pp#/proc/}"
        if ls -la "$pp"/exe | grep -q '(deleted)'; then
            ps h $pid
        fi
    done
}

