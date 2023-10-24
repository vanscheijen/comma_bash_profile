# Set default environment
umask 0022

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Disable any "!" (exclamation mark) expansion
set +o histexpand

# Notify of job termination immediatly
set -o notify

# Do not fork last pipe in command lines
shopt -s lastpipe &>/dev/null

# Better directory navigation
# Prepend cd to directory names automatically
shopt -s autocd &>/dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell &>/dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell &>/dev/null

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
#export CDPATH=".:~"

shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion
shopt -u hostcomplete

# Disable core dumps
ulimit -S -c 0

# No mail warnings
shopt -u mailwarn
unset MAILCHECK

[[ "$SHELL" =~ bash ]] || export SHELL=/bin/bash

# Use less alias as pager
export PAGER="less"

# Better history
export HISTTIMEFORMAT="%F %T "
export HISTSIZE=""
export HISTFILESIZE=""
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
bind Space:magic-space

# root user
if [[ "$EUID" == "0" ]]; then
    export TMOUT=3600 # logout after hour of inactivity
    export HOME=/root
    export LOGNAME=root
    export USER=root
    export HISTFILE=/root/.bash_history
    #/usr/bin/chattr +a "$HISTFILE"
    cd
fi

