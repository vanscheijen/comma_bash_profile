,decode () {
    local f_usage="<string | file | stdin>"
    local f_info="Decodes input automatically, detects binary|hexidecimal|base64|morse"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    local ddata
    if [[ "$data" =~ ^[01\ $LF]+$ ]]; then
        ddata="${data// /}"
        ddata="${ddata//$LF/}"
        while read -n8 -r byte; do
            [[ "$byte" ]] || continue
            printf "\\$(echo "obase=8; ibase=2; $byte" | bc)"
        done <<< "$ddata"
    elif [[ "$data" =~ ^[a-fA-F0-9x\ $LF]+$ ]]; then
        ddata="${data// /}"
        ddata="${ddata//$LF/}"
        ddata="${ddata//0x/}"
        local -i i
        for ((i=0; i<${#ddata}; i+=2)); do
            printf "%b" "\x${ddata:$i:2}"
        done
    elif [[ "$data" =~ ^[a-Z0-9+/\ $LF]+={0,2}$ ]]; then
        base64 -id <<< "$data"
    elif [[ "$data" =~ ^[·–—.\ \-\/#]*$ ]]; then
        local -A cw=(
            ['-----']=0
            ['.----']=1
            ['..---']=2
            ['...--']=3
            ['....-']=4
            ['.....']=5
            ['-....']=6
            ['--...']=7
            ['---..']=8
            ['----.']=9
            ['.-']=A
            ['-...']=B
            ['-.-.']=C
            ['-..']=D
            ['.']=E
            ['..-.']=F
            ['--.']=G
            ['....']=H
            ['..']=I
            ['.---']=J
            ['-.-']=K
            ['.-..']=L
            ['--']=M
            ['-.']=N
            ['---']=O
            ['.--.']=P
            ['--.-']=Q
            ['.-.']=R
            ['...']=S
            ['-']=T
            ['..-']=U
            ['...-']=V
            ['.--']=W
            ['-..-']=X
            ['-.--']=Y
            ['--..']=Z
            ['.----.']="'"
            ['-.-.--']='!'
            ['.-..-.']='"'
            ['------..-.-----']="%"
            ['.-...']='&'
            ['-.--.']='('
            ['-.--.-']=')'
            ['.-.-.']='+'
            ['--..--']=','
            ['-....-']='-'
            ['.-.-.-']='.'
            ['-..-.']='/'
            ['---...']=':'
            ['-.-.-.']=';'
            ['-...-']='='
            ['..--..']='?'
            ['.--.-.']='@'
            ['..--.-']='_'
            ['...-..-']='$'
            ['.-.-']=$LF
            ['.--.-']=Å
            ['-.-..']=Ć
            ['-.-..']=Ç
            ['----']=Ĥ
            ['..--.']=Ð
            ['..-..']=Ę
            ['.-..-']=Ł
            ['--.-.']=Ĝ
            ['.---.']=Ĵ
            ['--.--']=Ñ
            ['---.']=Ó
            ['---.']=Ø
            ['...-...']=Ś
            ['...-.']=Ŝ
            ['.--..']=Þ
            ['..--']=Ŭ
            ['--..-.']=Ź
            ['--..-']=Ż
            ['........']="<HH>"
            ['.-.-']="<AA>"
            ['.-.-.']="<AR>"
            ['.-...']="<AS>"
            ['-...-.-']="<BK>"
            ['-...-']="<BT>"
            ['-.-..-..']="<CL>"
            ['-.-.-']="<CT>"
            ['-..---']="<DO>"
            ['-.-.-']="<KA>"
            ['-.--.']="<KN>"
            ['...-.-']="<SK>"
            ['...-.']="<SN>"
            ['...---...']="<SOS>"
        )

        data="${data//·/.}"
        data="${data//–/-}"
        data="${data//—/-}"
        if [[ "$data" =~ (/|[.-][.-]) ]]; then
            ddata=$(sed "s/#//g; s# */ *#W#g; s/   */W/g; s/  */L/g" <<< "$data")
        else
            ddata=$(sed "s/#//g; s# */ *#W#g; s/       /W/g; s/   /L/g; s/ //g" <<< "$data")
        fi

        data=""
        IFS="W"
        for word in $ddata; do
            IFS="L"
            for letter in $word; do
                if [[ -v cw[$letter] ]]; then
                    data+="${cw[$letter]}"
                else
                    ,warning "Morse code letter '$letter' is unknown"
                fi
            done
            data+=" "
        done
        echo "${data% }"
    else
        ,warning "Could not detect encoding"
    fi
}

