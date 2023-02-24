,sum () {
    local f_usage="[file]"
    local f_info="Outputs the sum, average, min, and max of a list of numbers"

    local content
    [[ -s "$1" ]] || ,ifne || { ,,usage; return; }
    content=$(cat "${1:--}")

    [[ "$content" ]] && awk '{sum += $1; count++; if ($1 < min) { min = $1; }; if ($1 > max) {max = $1;}; } END {print "Sum:", sum, "Average:", sum/count, "Min:", min, "Max:", max;}' <<< "$content"
}

