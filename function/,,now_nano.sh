,,now_nano () {
    if ((BASH_VERSINFO[0] >= 5)); then
        echo "$EPOCHREALTIME"
    else
        date +%s.%N
    fi
}

