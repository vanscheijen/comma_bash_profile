,,now () {
    if ((BASH_VERSINFO[0] >= 5)); then
        echo "$EPOCHSECONDS"
    else
        date +%s
    fi
}

