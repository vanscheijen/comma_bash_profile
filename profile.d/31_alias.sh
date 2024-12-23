# Generic aliases
alias less="less -IMRn"
alias p="ps faux"
alias tmesg='dmesg|perl -ne "BEGIN{\$a= time()- qx!cat /proc/uptime!};s/\[\s*(\d+)\.\d+\]/localtime(\$1 + \$a)/e; print \$_;"'
alias mc="mc -u"

# Version dependent aliases
if diff --color=always -d --version &>/dev/null; then
    alias diff="diff --color=always -d"
fi
if grep --exclude-dir=.git --version &>/dev/null; then
    alias grep="grep --perl-regexp --color=auto --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg"
else
    alias grep="grep --perl-regexp --color=auto"
fi
if ls --hyperlink=auto --version &>/dev/null; then
    alias ls="ls -Fvla --color=always --hyperlink=auto"
else
    alias ls="ls -Fvla --color=always"
fi
if rm -I --version &>/dev/null; then
    alias rm="rm -vI"
else
    alias rm="rm -v"
fi

# Application specific aliases
,,have cal && alias cal="cal -y -w -m --color=auto"
,,have qrencode && alias ,qr="qrencode -lL -t UTF8i -o -"
,,have resolvectl && alias host="resolvectl query"
,,have docker && alias ,dockerize_cwd="docker run -it --rm --entrypoint /bin/sh -v \$PWD:/workdir -w /workdir alpine"
,,have btop && alias top="btop --utf-force"
,,have units && alias units="units -t"

# Use some rust alternatives if available. See https://zaiste.net/posts/shell-commands-rust/
[[ -d "$HOME/.cargo/bin" ]] && grep -q "$HOME/.cargo/bin" <<< "$PATH" || export PATH="$HOME/.cargo/bin:$PATH"
,,have dust && alias ,diskusage="dust"

# Superuser alias
if [[ "$EUID" == "0" ]]; then
    alias s=',notice "You are already root!"'
elif [[ -f /usr/bin/doas ]]; then
    alias s="/usr/bin/doas /bin/bash --init-file ~/.bash_profile"
    alias sudo="doas --"
    ,xdoas () {
        xhost +SI:localuser:root
        doas "$@"
        xhost -SI:localuser:root
        xhost
    }
elif [[ -f /usr/bin/sudo ]]; then
    alias s="/usr/bin/sudo -i /bin/bash --init-file ~/.bash_profile"
    ,xsudo () {
        xhost +SI:localuser:root
        sudo "$@"
        xhost -SI:localuser:root
        xhost
    }
fi

# Neovim settings
if [[ -f /usr/bin/nvim ]]; then
    export EDITOR="/usr/bin/nvim"
    alias vim="nvim"
    alias vimdiff="nvim -d"
elif [[ -f /usr/bin/vim ]]; then
    export EDITOR="/usr/bin/vim"
    alias vim="vim -u ~${SUDO_USER:-$USER}/.vimrc"
fi

# Kitty terminal emulator settings
if ,,have kitty; then
    source <(kitty + complete setup bash)
    alias kitty-diff="kitty +kitten diff"
    alias icat="kitty +kitten icat"
    alias kitty-grep="kitty +kitten hyperlinked_grep"
elif [[ "$TERM" == "xterm-kitty" ]]; then
    export TERM=xterm-256color
fi

