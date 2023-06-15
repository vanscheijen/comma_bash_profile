,morse () {
    local f_usage="[frequency] [wpm] <string | file | stdin>"
    local f_info="Output morse encoded text with optional audio beeps of [frequency] hertz (default 0 which means no audio) at [wpm] words per minute (default 60)"

    ,,require_bash4 || return

    local -A cw=(
        [0]='-----'
        [1]='.----'
        [2]='..---'
        [3]='...--'
        [4]='....-'
        [5]='.....'
        [6]='-....'
        [7]='--...'
        [8]='---..'
        [9]='----.'
        [A]='.-'
        [B]='-...'
        [C]='-.-.'
        [D]='-..'
        [E]='.'
        [F]='..-.'
        [G]='--.'
        [H]='....'
        [I]='..'
        [J]='.---'
        [K]='-.-'
        [L]='.-..'
        [M]='--'
        [N]='-.'
        [O]='---'
        [P]='.--.'
        [Q]='--.-'
        [R]='.-.'
        [S]='...'
        [T]='-'
        [U]='..-'
        [V]='...-'
        [W]='.--'
        [X]='-..-'
        [Y]='-.--'
        [Z]='--..'
        ["'"]='.----.'
        ['!']='-.-.--'
        ['"']='.-..-.'
        ['%']='------..-.-----'
        ['&']='.-...'
        ['(']='-.--.'
        [')']='-.--.-'
        ['*']='-..-'
        ['+']='.-.-.'
        [',']='--..--'
        ['-']='-....-'
        ['.']='.-.-.-'
        ['/']='-..-.'
        [':']='---...'
        [';']='-.-.-.'
        ['=']='-...-'
        ['?']='..--..'
        ['@']='.--.-.'
        ['_']='..--.-'
        ['`']='.----.'
        ['$']='...-..-'
        [$LF]='.-.-'
        [À]='.--.-'
        [Å]='.--.-'
        [Ä]='.-.-'
        [Ą]='.-.-'
        [Æ]='.-.-'
        [Ć]='-.-..'
        [Ĉ]='-.-..'
        [Ç]='-.-..'
        [Ĥ]='----'
        [Š]='----'
        [Ð]='..--.'
        [É]='..-..'
        [Ę]='..-..'
        [È]='.-..-'
        [Ł]='.-..-'
        [Ĝ]='--.-.'
        [Ĵ]='.---.'
        [Ń]='--.--'
        [Ñ]='--.--'
        [Ó]='---.'
        [Ö]='---.'
        [Ø]='---.'
        [Ś]='...-...'
        [Ŝ]='...-.'
        [Þ]='.--..'
        [Ü]='..--'
        [Ŭ]='..--'
        [Ź]='--..-.'
        [Ż]='--..-'
    )

    local -i i j frequency=0 wpm=60
    if [[ "$1" =~ ^[0-9]+$ && "$1" -ge 0 && "$1" -lt 24000 ]]; then
        frequency=$1
        shift
    fi
    if [[ "$1" =~ ^[0-9]+$ && "$1" -ge 0 && "$1" -lt 500 ]]; then
        wpm=$1
        shift
    fi
    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    local char code morse=""
    for ((i=0; i<${#data}; i++)); do
        char="${data:$i:1}"
        char="${char^^}"
        if [[ "$char" == " " ]]; then
            morse+="    "
        elif [[ "${cw[$char]}" ]]; then
            code="${cw[$char]}"
            for ((j=0; j<${#code}; j++)); do
                morse+="${code:$j:1} "
            done
            morse+="  "
        else
            ,warning "Cannot convert $RED$(,unhide <<< "$char")$RESET into morse"
        fi
    done
    echo "$morse"

    ((frequency == 0)) && return
    ,,require sox || return

    local duration_dit duration_dah
    duration_dit=$(bc <<< "scale=2; 12 / $wpm")
    duration_dah=$(bc <<< "scale=2; $duration_dit * 3")
    local -r ditfile="${TMPDIR:-/tmp}/,morse_dit.wav"
    local -r dahfile="${TMPDIR:-/tmp}/,morse_dah.wav"
    local -r spacefile="${TMPDIR:-/tmp}/,morse_space.wav"
    local -r morsefile="${TMPDIR:-/tmp}/,morse.wav"
    local -r morsefile1="${TMPDIR:-/tmp}/,morse1.wav"
    local -r morsefile2="${TMPDIR:-/tmp}/,morse2.wav"

    sox -r 48000 -b 16 -n "$ditfile" synth $duration_dit sin $frequency 2>/dev/null
    sox -r 48000 -b 16 -n "$dahfile" synth $duration_dah sin $frequency 2>/dev/null
    sox -r 48000 -b 16 -n "$spacefile" trim 0.0 $duration_dit 2>/dev/null

    local wavs_in_order=""

    i=0
    while ((i < ${#morse})); do
        case "${morse:$i:1}" in
            ".") wavs_in_order+="$ditfile " ;;
            "-") wavs_in_order+="$dahfile " ;;
            " ") wavs_in_order+="$spacefile " ;;
        esac

        if ((i == 0)); then
            rm -f "$morsefile1" "$morsefile2" "$morsefile"
        elif ((i % 512 == 0 || i == ${#morse} - 1)); then
            sox $wavs_in_order "$morsefile1"
            if [[ -f "$morsefile" ]]; then
                mv "$morsefile" "$morsefile2"
                sox "$morsefile1" "$morsefile2" "$morsefile"
            else
                mv "$morsefile1" "$morsefile"
            fi
            wavs_in_order=""
        fi
        ((i++))
    done

    play -q "$morsefile"
}

