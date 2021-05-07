,extract () {
    local f_usage="<compressed file>"
    local f_info="Automatically extract file using appropiate tool"

    [[ -s "$1" ]] || { ,,usage; return; }

    case $1 in
        *.tar.gz|*.tar.bz2|*.tar.xz|*.tar.lzip|*.tar.lzma|*.tar.lzop|*.tar.Z|*.tar.zstd|*.tbz2|*.tgz|*.tar)
                tar xvafkp "$1" ;;
        *.rar)  unrar x "$1" ;;
        *.zip)  unzip "$1" ;;
        *.7z)   7z x "$1" ;;
        *.gz)   gunzip "$1" ;;
        *.bz2)  bunzip2 "$1" ;;
        *.Z)    uncompress "$1" ;;
        *)      ,error "'$1' is an unknown compression format" ;;
    esac

    # TODO: protect against zipbomb (how?)
    # TODO: use mimetype instead of suffix?
    # TODO: always ensure extraction goes inside a directory, and move back if only 1 dir is extracted
}

