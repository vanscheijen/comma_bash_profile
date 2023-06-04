,analyze () {
    local f_usage="<filename>"
    local f_info="Perform binary distribution analysis on file, highlight LF, space, and A-z"

    [[ -s "$1" ]] || { ,,usage; return; }

    # https://en.wikipedia.org/wiki/Chi-square_distribution
    local freqdist
    read -r -d '' freqdist <<EOF
import sys
import collections
import math

file = open(sys.argv[1], 'rb')
text = file.read()
N = len(text)
nc = collections.Counter(text)
E = N / len(nc)

for c in range(0,255):
    n = 0
    CS = 0.0
    if c in nc:
        n = nc[c]
        CS = (n - E) ** 2 / E
    print("%d %d %.6f" % (c, n, CS))
EOF
    local tmpfile
    tmpfile="$(mktemp)"
    python - "$1" <<< "$freqdist" | sort -n >| "$tmpfile"

    # TODO: Automatically-remove 0-byte when it peaks, this occurs in binaries and compressed formats somehow
    # or just remove peaks all together with a notice? or give option to remove peaks?
    # python - "$1" <<< "$freqdist" | sort -n | grep -v "^0 " >| "$tmpfile"

    ,plot "'$tmpfile' using 1:2:(\$1==10 || \$1==32 ? 0 : \$1>=65 && \$1 <= 122 ? 1 : 2) with boxes palette title 'frequency', '' using 1:3 with lines title 'chi-square' linecolor 'purple'
        set style fill transparent solid 0.5 noborder
        set boxwidth 0.95 relative
        set palette model RGB defined (0 'green', 1 'yellow', 2 'red')
        set xlabel 'ASCII character set'
        set xrange[0:256]"
    /bin/rm -f "$tmpfile"

    # https://en.wikipedia.org/wiki/Index_of_coincidence
    # https://en.wiktionary.org/wiki/Shannon_entropy
    local edecoder
    read -r -d '' edecoder <<EOF
import sys
import collections
import math

file = open(sys.argv[1], 'rb')
text = file.read()
N = len(text)
nc = collections.Counter(text)
IC = 0.0
SE = 0.0

for c in nc:
    n = nc[c]
    Pi = n / N
    IC += Pi * (n - 1) / (N - 1)
    SE += Pi * (math.log(Pi, 2))

SE = SE * -1

print("%.6f %.6f" % (IC, SE))
EOF

    local ao
    ao="$(python - "$1" <<< "$edecoder")"
    local IC SE
    read IC SE <<< "$ao"
    ,info "Index of Coincidence"
    echo "0 ---- $IC ---- 1"
    ,info "Shannon's diversity index"
    echo "$SE"
}

