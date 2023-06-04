,zodiac () {
    local f_usage="<birthday>"
    local f_info="Returns zodiac information about a given <birthday>"

    local month day birthday="$1"
    month="$(date -d $birthday +%m)"
    day="$(date -d $birthday +%d)"

    case $month in
        01) ((day <= 19)) && echo "Capricorn" || echo "Aquarius" ;;
        02) ((day <= 18)) && echo "Aquarius" || echo "Pisces" ;;
        03) ((day <= 20)) && echo "Pisces" || echo "Aries" ;;
        04) ((day <= 19)) && echo "Aries" || echo "Taurus" ;;
        05) ((day <= 20)) && echo "Taurus" || echo "Gemini" ;;
        06) ((day <= 20)) && echo "Gemini" || echo "Cancer" ;;
        07) ((day <= 22)) && echo "Cancer" || echo "Leo" ;;
        08) ((day <= 22)) && echo "Leo" || echo "Virgo" ;;
        09) ((day <= 22)) && echo "Virgo" || echo "Libra" ;;
        10) ((day <= 22)) && echo "Libra" || echo "Scorpio" ;;
        11) ((day <= 21)) && echo "Scorpio" || echo "Sagittarius" ;;
        12) ((day <= 21)) && echo "Sagittarius" || echo "Capricorn" ;;
        *) echo "Invalid date" ;;
    esac
}

