,decode () {
    local f_usage="<string>"
    local f_info="Decode string, detects binary|hexidecimal"

    # Idea list: Caesar cipher, Atbash cipher, Rail Fence cipher, Polybius square, Base64 encoding, Bacon's cipher, Morse code, Book cipher, Vigenère cipher
    #  Playfair cipher, Autokey cipher, Beaufort cipher, Hill cipher, One-time pad, Transposition cipher, Substitution cipher, Columnar transposition cipher 

    local string="$1"
    if [[ "$string" =~ ^[01\ ]*$ ]]; then
        local binstring="$string"
        while read -n8 -r byte; do
            printf "\\$(echo "ibase=2; $byte" | bc)"
        done <<< "$binstring"
    elif [[ "$string" =~ ^[a-fA-F0-9\ ]*$ ]]; then
        local hexstring="${string// /}"
        for ((i = 0; i < ${#hexstring}; i += 2)); do
            printf "%b" "\x${hexstring:$i:2}"
        done
    fi
}

