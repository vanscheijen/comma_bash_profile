,cheat () {
    local f_usage="<command>"
    local f_info="Retrieve cheat.sh cheatsheets for most commands"

    ,,require curl || return

    local cachedir="${TMPDIR:-/tmp}/,cheat"
    mkdir -p "$cachedir"

    [[ -s "$cachedir/$@" ]] && { cat "$cachedir/$@"; return; }

    [[ -s "$cachedir/:list" ]] ||  curl -sf "https://cheat.sh/:list" -o "$cachedir/:list"
    grep -q "^$@$" "$cachedir/:list" || { ,warning "'$@' is unlisted, skipping query"; return; }

    curl -sf "https://cheat.sh/$@" -o "$cachedir/$@" && cat "$cachedir/$@" || ,error "Failed retrieving cheat.sh/$@"
}

