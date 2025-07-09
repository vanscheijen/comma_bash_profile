,extract () {
    local f_usage="<compressed archive file>"
    local f_info="Automatically extract archive file using the appropiate decompression tool into the current working directory"

    local archive
    archive=$(realpath -e "$1" 2>/dev/null)
    [[ $? == 0 && -s "$archive" ]] || { ,,usage; return; }

    local tool=""
    case $archive in
        *.tar.gz|*.tar.bz2|*.tar.xz|*.tar.lzip|*.tar.lzma|*.tar.lzop|*.tar.Z|*.tar.zstd|*.tbz2|*.tgz|*.tar)
                tool="tar xvafkp" ;;
        *.rar)  tool="unrar x" ;;
        *.zip)  tool="unzip" ;;
        *.7z)   tool="7z x" ;;
        *.gz)   tool="gunzip" ;;
        *.bz2)  tool="bunzip2" ;;
        *.Z)    tool="uncompress" ;;
        *)
            case $(file -b --mime-type -- "$archive") in
                application/zip) tool="unzip" ;;
            esac
    esac

    [[ "$tool" ]] || { ,error "'$archive' has an unknown compression format"; return 62; }

    ,info "Using $tool to extract '$archive'"
    local origdir="$PWD"
    local tmpdir newname dircount filecount
    tmpdir="$(mktemp -d -p "$origdir")"
    cd "$tmpdir" && $tool "$archive"
    cd "$origdir"
    dircount=$(\ls -d1q "$tmpdir/" | wc -l)
    filecount=$(\ls -1q "$tmpdir/" | wc -l)
    if [[ $dircount -eq 1 && $filecount -eq 1 ]]; then
        mv -i "$tmpdir/"* "$origdir/"
        rmdir "$tmpdir"
    elif [[ $filecount -eq 0 ]]; then
        rmdir "$tmpdir"
    else
        newname="${1%.*}"
        newname="${1%.*}"
        [[ -e "$newname" ]] && newname="${newname}-extract"
        mv "$tmpdir" "$newname"
    fi

    # TODO: protect against zipbomb (how?)
}

