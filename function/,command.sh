,command () {
    local f_usage="<command> [arguments...]"
    local f_info="Treat the <command> with optional <arguments...> as a simple command, suppressing any shell function lookups, wrong paths, etc."

    # Stolen from man page of 'command'

    IFS=' '$'\t'$'\n'
    #    The preceding value should be <space><tab><newline>.
    #    Set IFS to its default value.

    \unalias -a
    #    Unset all possible aliases.
    #    Note that unalias is escaped to prevent an alias
    #    being used for unalias.

    unset -f command
    #    Ensure command is not a user function.

    PATH="$(command -p getconf PATH):$PATH"
    #    Put on a reliable PATH prefix.

    command "$@"
}

