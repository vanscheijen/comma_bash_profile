## Generic aliases
alias less="less -IMRn"
alias p="ps faux"

## Version dependent aliases
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

## Application specific aliases
,have cal && alias cal="cal -y -w -m --color=auto"
,have qrencode && alias ,qr="qrencode -lL -t UTF8i -o -"
,have resolvectl && alias host="resolvectl query"
,have docker && alias ,dockerize_cwd="docker run -it --rm --entrypoint /bin/sh -v \$PWD:/workdir -w /workdir alpine"

## Use rust alternatives if available
# https://zaiste.net/posts/shell-commands-rust/
[[ -d "$HOME/.cargo/bin" ]] && grep -q "$HOME/.cargo/bin" <<< "$PATH" && export PATH="$HOME/.cargo/bin:$PATH"

,have dust && alias ,diskusage="dust"
if ,have rg; then
    ,,rg () {
        local arg
        for arg; do
            [[ "$arg" == "-r" ]] && shift
            [[ "$arg" == "-ri" ]] && { shift; set -- '-i' "$@"; }
        done
        rg "$@"
    }
    alias grep=",,rg"
fi
,have ytop && alias top="ytop"
,have exa && alias exa="exa -FlaG --color=always"
#,have fd && alias find="fd"
#,have procs && alias p="procs"

## Superuser alias
if [[ "$EUID" == "0" ]]; then
    alias s=",notice \"You're already root!\""
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

## Neovim settings
if [[ -f /usr/bin/nvim ]]; then
    export EDITOR="/usr/bin/nvim"
    alias vim="nvim"
    alias vimdiff="nvim -d"
elif [[ -f /usr/bin/vim ]]; then
    export EDITOR="/usr/bin/vim"
    alias vim="vim -u ~${SUDO_USER:-$USER}/.vimrc"
fi

## Kitty terminal emulator settings
if ,have kitty; then
    source <(kitty + complete setup bash)
    export KITTY_ENABLE_WAYLAND=1
    alias kitty-diff="kitty +kitten diff"
    alias icat="kitty +kitten icat"
elif [[ ! -f ~/.terminfo/x/xterm-kitty ]]; then
    export TERM=xterm-256color
fi

