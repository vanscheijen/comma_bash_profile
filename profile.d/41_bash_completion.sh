## Fix bash completion
complete -A hostname   telnet ping ssh
complete -A export     printenv env
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su
complete -A helptopic  help
complete -A shopt      shopt
complete -A stopped -P "%" bg
complete -A job -P "%" fg jobs disown
complete -A directory  mkdir rmdir

# Compatible have version needed for some older machines and bash_completion scripts
have () {
    unset -v have
    PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin" type "$1" &>/dev/null && have="yes"
}

[[ -f /etc/bash_completion ]] && source /etc/bash_completion

for i in /etc/bash_completion.d/*; do
    [[ -r "$i" ]] && source "$i" &>/dev/null # ignore errors
done
unset -v i

unset -f have

