,ansi_vars () {
    local f_info="Show most ANSI variables with their effect, can be used with ,echo"

    readonly -p | awk '/\\033/ { sub(/=.*/, ""); print $3 }' | while read ansi; do
        if [[ "$ansi" =~ ^(CURSOR_.*|ERASE_.*|SCROLL_.*) ]]; then
            echo "\${$ansi}"
        else
            ,echo "\${${!ansi}${ansi}${RESET}}"
        fi
    done
}

