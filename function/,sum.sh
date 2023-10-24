,sum () {
    local f_usage="<string | file | stdin>"
    local f_info="Outputs the sum, average, min, and max of a list of numbers"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)" || { ,,usage; return; }

    ,sep2sep -s a n <<< "$data" | awk '(NR==1) { min = $1; max = $1; } {sum += $1; count++; if ($1 < min) { min = $1; }; if ($1 > max) {max = $1;}; } END {print "Sum:", sum, "Average:", sum/count, "Min:", min, "Max:", max;}'
}

