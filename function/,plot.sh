,plot () {
    local f_usage="[3d] <formula> "'[ <gnuplot command>; ... ]'
    local f_info="Plots a formula via gnuplot and present it via kitty icat within the terminal window"
    local f_example=",plot 'sin(x*3)*exp(x*.2)'; ,plot 3d 'x**2+y**2, x**2-y**2'"

    ,,require gnuplot || return
    [[ "$1" ]] || { ,,usage; return; }

    local plot="plot"
    if [[ $1 == "3d" ]]; then
        plot="splot"
        shift
    fi
    local formula="$1"
    shift

    cat <<- IPLOT | gnuplot
set datafile separator ' '
set key fixed right top vertical Right noreverse enhanced autotitle box lt black linewidth 1.000 dashtype solid
set autoscale
set samples 100
set colorsequence podo
set style fill solid 0.50 noborder
set terminal pngcairo transparent truecolor enhanced fontscale 1.8 size 1280, 800 font 'FiraCode Nerd Font,10'
set output '|kitty +kitten icat --stdin yes'
set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb "#ababab" behind
${@//;/$LF}
$plot $formula
set output '/dev/null'
IPLOT
}

