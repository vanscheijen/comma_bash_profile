# BEGIN EXCLUDE
,asciirecord () {
    local f_info="Immediatly records terminal session with asciinema"

    ,,require asciinema || return

    asciinema rec "`mktemp ~/Pictures/Recording/"$(date +%Y-%m-%d-%H-%M-%S)-XXX" --suffix=.cast`"
}
# END EXCLUDE
