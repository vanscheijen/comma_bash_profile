# Set bash prompt

USER_COLOR="${DIM}${DIMCYAN}"
[[ "$EUID" == "0" ]] && USER_COLOR="$RED"

# Update history and re-enable output with each command
export PROMPT_COMMAND="history -a; stty echo"

# Update previous timestamp into italic
# NOTE: Disabled until I find a better way to handle multiline input
#export PS0="\[${CURSOR_PREVLINE}${RESET}${ITALIC}${WHITE}\]\t\[${CURSOR_NEXTLINE}${RESET}\]"

# start of title: \e]0;
# end of title: \a
# start of non-printable characters: \[
# end of non-printable characters: \]
export PS1="\[\e]0;\h (pts/\l #\#) \w\a\]\[${RESET}${WHITE}\]\t\[${XITALIC}${DIM}${DIMGRAY}\](\[${XDIM}\]j\[${BLUE}\]\j\[${DIMGRAY}\] x\`EV=\$?; [[ \$EV == 0 ]] && printf \[${YELLOW}\]0 || printf \[${RED}\]\$EV;,,git_ps1_info \[ \]\`\[${RESET}${DIM}${DIMGRAY}\])\[${XDIM}${USER_COLOR}\]\u\[${RESET}${DIMGRAY}\]@\[${GRAY}\]\h\[\`[[ -w \$PWD ]] && printf $GREEN || printf $RED\`\]:\[${WHITE}\]\w\[${GRAY}\]>\[${RESET}${CURSOR_SHOW}\] "

