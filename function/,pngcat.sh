,pngcat() {
    local f_usage="<png file>"
    local f_info="Shows a png file using the graphics escape code (e.g. with Kitty terminal)"

    local data
    [[ "$1" ]] || { ,,usage; return; }
    data="$(base64 "$1")"
    data="${data//[[:space:]]}"

    local -i pos=0 chunk_size=4096
    while [[ $pos -lt ${#data} ]]; do
        printf "\e_G"
        [[ $pos = "0" ]] && printf "a=T,f=100,"
        local chunk="${data:$pos:$chunk_size}"
        pos=$(($pos+$chunk_size))
        [[ $pos -lt ${#data} ]] && printf "m=1"
        [[ ${#chunk} -gt 0 ]] && printf ";%s" "${chunk}"
        printf "\e\\"
    done
}

