# Bash calls this function (see man bash)
command_not_found_handle () {
    ,error "$1: command not found"
}

# Go up the directory path, shortcut for "cd ..", can also use with "up 2" for doing it twice
up () {
    local -i i
    for ((i=0; i < ${1:-1}; i++)); do
        cd ..
    done
}

# It's possible to use / in a function name, you cannot tab-complete them which makes them semi-hidden
/me () {
    ,echo "$(whoami) $*"
}

