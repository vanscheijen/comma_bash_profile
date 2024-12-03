# Login prompt

if shopt -q login_shell; then
    ,version
    ,box "$(uname -a)"
    w
fi

