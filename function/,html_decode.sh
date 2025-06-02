,html_decode () {
    local f_usage="<string | file | stdin>"
    local f_info="Outputs HTML decoded to plain text"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    /usr/bin/perl -pe "s/&amp;/&/g;s/&lt;/</g;s/&gt;/>/g;s/&quot;/\"/g;s/&apodata;/'/g;s/<[^ ].*?>/ /g" <<< "$data"
}

