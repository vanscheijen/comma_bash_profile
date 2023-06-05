,command () {
    local f_usage="<command> [arguments...]"
    local f_info="Treat the <command> with optional <arguments...> as a simple command, suppressing any shell function lookups, wrong paths, etc."

    # Run inside a subshell
    (
        # Set IFS to its default value of <space><tab><newline>.
        IFS=' '$'\t'$'\n'

        # Unset all possible aliases including unalias itself.
        \unalias -a

        # Ensure command is not a user function.
        \unset -f command

        # Put on a reliable PATH prefix.
        PATH="$(command -p getconf PATH):$PATH"

        command "$@"
    )
}

