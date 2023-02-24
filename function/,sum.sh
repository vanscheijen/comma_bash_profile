,sum () {
    local f_info="Outputs the sum, average, min, and max of a list of numbers"

    ,ifne cat "${1--}" | awk '{sum += $1; count++; if ($1 < min) { min = $1; }; if ($1 > max) {max = $1;}; } END {print "Sum:", sum, "Average:", sum/count, "Min:", min, "Max:", max;}'
}

