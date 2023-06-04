# BEGIN EXCLUDE
# This function can be used as a bootstrap and therefor should *not* be
# dependent on (internal) comma functions or declarations.
,,make_profile () {
    [[ -d "$COMMA_PROFILEDIR" ]] || { ,,usage; return 61; }

    local tmpfile
    tmpfile="$(mktemp)"
    local profile="$COMMA_PROFILEDIR/.bash_profile"

    # Generate profile
    cat "$COMMA_PROFILEDIR/head.sh" "$COMMA_PROFILEDIR/function/"*.sh "$COMMA_PROFILEDIR/profile.d/"*.sh "$COMMA_PROFILEDIR/tail.sh" >| "$tmpfile"
    sed -i "s/^# %COMMA_DATE_GENERATED%$/COMMA_DATE_GENERATED=\"$(date +%Y-%m-%d)\"/" "$tmpfile"

    ,,test_profile () {
        [[ -f "$profile" ]] && diff -q "$profile" "$tmpfile" &>/dev/null && return 1
        bash -n "$tmpfile" || return 2
        type bashate &>/dev/null && { bashate "$tmpfile" -i E006,E043 || return 3; }
        return 0
    }

    # Update if profile is valid
    local -i updated
    if ,,test_profile; then
        # Show difference
        [[ -f "$profile" ]] && diff --color=always -d -u "$profile" "$tmpfile"

        # Backup and replace active profile
        cp -f "$profile" "${profile}.backup" &>/dev/null
        cp -f "$tmpfile" "$profile"
        updated=1
    else
        # It's ok to use ,ok here; it's not a dependency.
        ,ok "Nothing changed!"
    fi

    # Cleanup
    /bin/rm -f "$tmpfile"
    unset -f ,,test_profile

    # Run new profile
    ((updated > 0)) && exec bash --init-file "$profile" -l || return 0
}

,make_profile () {
    local f_info="Generate the Comma .bash_profile from files in $COMMA_PROFILEDIR"

    if [[ -z "$COMMA_PROFILEDIR" ]]; then
        COMMA_PROFILEDIR="$HOME/.local/share/comma_bash_profile"
        echo "COMMA_PROFILEDIR was not set, defaulting to $COMMA_PROFILEDIR"
    fi

    # Reload this file to effectuate changes immediatly
    source "$COMMA_PROFILEDIR/function/,make_profile.sh"
    ,,make_profile
}
# END EXCLUDE
