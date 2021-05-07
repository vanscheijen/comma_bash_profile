,html_encode () {
    s="${1//&/&amp;}"
    s="${s//</&lt;}"
    s="${s//>/&gt;}"
    s="${s//'"'/&quot;}"
    echo "$s"
}

