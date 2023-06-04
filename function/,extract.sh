,extract () {
    local f_usage="<compressed file>"
    local f_info="Automatically extract file using appropiate tool"

    [[ -s "$1" ]] || { ,,usage; return; }

    local tool=""
    case $1 in
        *.tar.gz|*.tar.bz2|*.tar.xz|*.tar.lzip|*.tar.lzma|*.tar.lzop|*.tar.Z|*.tar.zstd|*.tbz2|*.tgz|*.tar)
                tool="tar xvafkp" ;;
        *.rar)  tool="unrar x" ;;
        *.zip)  tool="unzip" ;;
        *.7z)   tool="7z x" ;;
        *.gz)   tool="gunzip" ;;
        *.bz2)  tool="bunzip2" ;;
        *.Z)    tool="uncompress" ;;
        *)
            case $(file -b --mime-type -- "$1") in
                application/zip) tool="unzip" ;;
            esac
    esac

    [[ "$tool" ]] || { ,error "'$1' has an unknown compression format"; return 62; }
    ,info "Using $tool to extract '$1'"
    local origdir="$PWD"
    local tmpdir
    tmpdir="$(mktemp -d -p "$PWD")"
    cd "$tmpdir" && $tool "$origdir/$1"
    cd "$origdir"
    if [[ $(\ls -d1q "$tmpdir/" | wc -l) -eq 1 && $(\ls -1q "$tmpdir/" | wc -l) -eq 1 ]]; then
        mv -i "$tmpdir/"* "$origdir/"
        rmdir "$tmpdir"
    else
        local newname="${1%%.*}"
        [[ -e "$newname" ]] && newname="${newname}-extract"
        mv "$tmpdir" "$newname"
    fi

    # TODO: protect against zipbomb (how?)
}

