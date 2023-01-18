,html_encode () {
    local f_usage="<string>"
    local f_info="Simple encoding of <string> to be HTML compatible"

    s="${1//&/&amp;}"
    s="${s//</&lt;}"
    s="${s//>/&gt;}"
    s="${s//'"'/&quot;}"
    s="${s//"'"/&apos;}"
    echo "$s"
}

