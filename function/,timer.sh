,timer () {
    local f_usage="[ [''] | <time> [action] | <'stop'> <pid> ]"
    local f_info="Countdown timer, no arguments give a list of timers. <time> is simply formatted like '1d2h3m4s' (1 day, 2 hours, 3 minutes, 4 seconds)"

    local time="$1"
    local action="$2"
    local tmpdir
    local -i alarmtime
    local -i now
    now=$(,,now)

    # No given argument gives a list of current running timers
    if [[ -z "$time" ]]; then
        pgrep ",,timer_alarm" | while read timerpid; do
            tmpdir="${TMPDIR:-/tmp}/,timer.$timerpid"
            alarmtime=$(< $tmpdir/alarmtime)
            ,info "In $((alarmtime - now)) seconds | Timer pid: $timerpid alarmtime: $alarmtime action: $(< $tmpdir/action)"
        done
        return
    fi

    # Stop argument, stops a timer with given pid
    if [[ "$time" == "stop" && "$action" -gt 1 ]]; then
        pgrep -l ",,timer_alarm" | grep -q "^$action" || { ,error "There is no timer with pid $action"; return 58; }

        ,notice "Killing timer process $action"
        kill -- -$action
        return
    fi

    # Parse given time or present usage if no valid arguments were given
    [[ "$time" =~ ^[0-9]+$ ]] && time="${time}s"
    [[ "$time" =~ ^[0-9smhd\ ]+$ ]] || { ,,usage; return; }
    time="${time//s/SECONDS+}"
    time="${time//m/MINUTES+}"
    time="${time//h/HOURS+}"
    time="${time//d/DAYS+}"
    time="+${time%%+}"
    alarmtime=$(date -d "$time" +%s)
    ((alarmtime - now > 4)) || { ,error "Why would you need to time such a short amount‽"; return 56; }

    # Set default action if not given
    [[ "$action" ]] || action="notify-send 'Timer $1 finished, started at $(date -d @$now +%H:%M:%S) and stopped at $(date -d @$alarmtime +%H:%M:%S)'"

    # Backup process name and set new name for fork
    local procname
    procname=$(< /proc/$$/comm)
    printf ",,timer_alarm" >| /proc/$$/comm

    # Start timer process in background
    {
        (
            ,,timer_aborted() {
                ,have espeak && espeak -a 200 "The timer was aborted" &
                exit
            }

            ,,timer_cleanup() {
                rm -rf "${TMPDIR:-/tmp}/,timer.$BASHPID/"
            }

            trap ",,timer_aborted" SIGTERM
            trap ",,timer_cleanup" SIGEXIT

            set -e
            # Wait until alarmtime is reached in half the time-to-wait
            # - less sleep forks, still somewhat compatible with sleeping procs
            local wait
            until ((now > alarmtime)); do
                (( (wait=(alarmtime - now) / 2) > 0 )) || wait="1"
                sleep $wait
                now=$(,,now)
            done
            ,have espeak && espeak -a 200 "The timer has finished" &
            eval $action
        ) &
        local timerpid=$!
        disown $timerpid
    } &>/dev/null
    ,info "Timer started with pid: $timerpid"

    # Restore process name
    printf "$procname" >| /proc/$$/comm

    # Write timer information in tmpdir
    local tmpdir="${TMPDIR:-/tmp}/,timer.$timerpid"
    mkdir -p "$tmpdir" || { ,warning "Could not create '$tmpdir', timer will run but no information available in listing"; return 57; }
    echo "$alarmtime" >| "$tmpdir"/alarmtime
    echo "$action" >| "$tmpdir"/action
}

