if [[ -f ~/.bashrc ]]; then
    grep -q "COMMA_VERSION" ~/.bashrc || source ~/.bashrc
fi

