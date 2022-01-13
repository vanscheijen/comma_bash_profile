# vi-like bash
set -o vi
bind 'set show-mode-in-prompt on'
bind "set vi-ins-mode-string \1${CURSOR_STYLE_HLINE}\2"
bind "set vi-cmd-mode-string \1${CURSOR_STYLE_BLOCK}\2"
# switch to normal mode before executing a command (literaly presses escape before enter)
bind 'RETURN: "\e\n"'

# Idea of setting whole window background color, but it's annoying
#bind "set vi-ins-mode-string \1${CURSOR_STYLE_HLINE}`TERMRGBCOLOR 000000`\2"
#bind "set vi-cmd-mode-string \1${CURSOR_STYLE_BLOCK}`TERMRGBCOLOR 113355`\2"

# Readline customizations
bind 'set bell-style visible'
bind 'set blink-matching-paren on'
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'
bind 'set mark-symlinked-directories on'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-unmodified on'
bind 'set enable-bracketed-paste on'
bind 'set completion-query-items -1'
bind 'set page-completions off'
bind 'set print-completions-horizontally on'
bind 'set visible-stats on'

# Ctrl-z switches between background and foreground
bind -x '"\C-z":"fg"'
# Keep Ctrl-q for emergency bg in bash (sometimes ctrl-z is ignored)
stty susp ''

# disable vi-redo so alt-. works normally
bind -m vi-command -r '.'

# restore some emacs keybindings in vi mode
while read -r binding; do
    for keymap in vi-command vi-insert; do
        bind -m $keymap "$binding"
    done
    unset -v keymap
done <<EOF
"\C-l":clear-screen
"\C-g":abort
"\e[1;5C":vi-next-word
"\e[1;5D":vi-prev-word
"\e.":yank-last-arg
"\C-x\C-e":edit-and-execute-command
"\C-w":backward-kill-word
"\e[H":beginning-of-line
"\e[F":end-of-line
"\eOH":beginning-of-line
"\eOF":end-of-line
"\e[1~":beginning-of-line
"\e[4~":end-of-line
" ":magic-space
"\C-a":beginning-of-line
"\C-e":end-of-line
"\C-k":kill-line
"\eb":backward-word
"\ef":forward-word
"\ew":kill-word
"\em":"\e0wi"
"\e\e":edit-and-execute-command
"\e[A":history-search-backward
"\e[B":history-search-forward
EOF
unset -v binding

# enable forward search (ctrl-s)
stty -ixon

