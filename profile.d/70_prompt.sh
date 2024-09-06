# Set bash prompt

USER_COLOR="${DIMGREEN}"
[[ "$EUID" == "0" ]] && USER_COLOR="${RED}"

# Update history, re-enable output, and show fake-newline if not present
export PROMPT_COMMAND="history -a; stty echo; pos=\$(CURSOR_GET 2>/dev/null); [[ \${pos#* } -gt 1 ]] && printf \"\${RED}\${RESET}\${LF}\""

# Update previous timestamp into italic
# NOTE: Disabled until I find a better way to handle multiline input
#export PS0="\[${CURSOR_PREVLINE}${RESET}${ITALIC}${WHITE}\]\t\[${CURSOR_NEXTLINE}${RESET}\]"

# start of title: \e]0;
# end of title: \a
# start of non-printable characters: \[
# end of non-printable characters: \]
export PS1="\[\e]0;\h (pts/\l #\#) \w\a\]\[${RESET}${WHITE}\]\t\[${XITALIC}${DIMGRAY}\](\[${XDIM}\]j\[${BLUE}\]\j\[${DIMGRAY}\] x\$(EV=\$?; [[ \$EV == 0 ]] && printf \[${YELLOW}\]0 || printf \[${RED}\]\$EV;[[ \$SHLVL -gt 1 ]] && printf \[${DIMGRAY}\]\ s\[${CYAN}\]\$SHLVL;,,ps1_git_info \[ \])\[${RESET}${DIMGRAY}\])\[${XDIM}${USER_COLOR}\]\u\[${RESET}${DIMGRAY}\]@\[${GRAY}\]\h\[\$([[ -w \$PWD ]] && printf $GREEN || printf $RED)\]:\[${WHITE}\]\w\[${GRAY}\]>\[${RESET}${CURSOR_SHOW}\] "
export PS2="${RESET}${DIMGRAY}> ${RESET}"

