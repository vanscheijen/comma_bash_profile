## ANSI escape sequences

# Set graphical renditions
readonly RESET="\033[0m"
readonly BOLD="\033[1m"
readonly DIM="\033[2m"
readonly ITALIC="\033[3m"
readonly UNDERLINE="\033[4m"
readonly BLINK="\033[5m"
readonly BLINK_FAST="\033[6m"
readonly INVERTED="\033[7m"
readonly HIDDEN="\033[8m"
readonly CROSSED="\033[9m"

# Remove graphical renditions
readonly XRESET="\033[20m"
readonly XBOLD="\033[21m" # double underline in kitty (bug?)
readonly XDIM="\033[22m"
readonly XITALIC="\033[23m"
readonly XUNDERLINE="\033[24m"
readonly XBLINK="\033[25m"
readonly XBLINK_FAST="\033[26m"
readonly XINVERTED="\033[27m"
readonly XHIDDEN="\033[28m"
readonly XCROSSED="\033[29m"

# Set dark foreground colors
readonly BLACK="\033[30m"
readonly DIMRED="\033[31m"
readonly DIMGREEN="\033[32m"
readonly DIMYELLOW="\033[33m"
readonly DIMBLUE="\033[34m"
readonly DIMPURPLE="\033[35m"
readonly DIMCYAN="\033[36m"
readonly GRAY="\033[37m"

# Set bright foreground colors
readonly DIMGRAY="\033[90m"
readonly RED="\033[91m"
readonly GREEN="\033[92m"
readonly YELLOW="\033[93m"
readonly BLUE="\033[94m"
readonly PURPLE="\033[95m"
readonly CYAN="\033[96m"
readonly WHITE="\033[97m"

# Set dark background colors
readonly BGBLACK="\033[40m"
readonly BGDIMRED="\033[41m"
readonly BGDIMGREEN="\033[42m"
readonly BGDIMYELLOW="\033[43m"
readonly BGDIMBLUE="\033[44m"
readonly BGDIMPURPLE="\033[45m"
readonly BGDIMCYAN="\033[46m"
readonly BGGRAY="\033[47m"

# Set bright background colors
readonly BGDIMGRAY="\033[100m"
readonly BGRED="\033[101m"
readonly BGGREEN="\033[102m"
readonly BGYELLOW="\033[103m"
readonly BGBLUE="\033[104m"
readonly BGPURPLE="\033[105m"
readonly BGCYAN="\033[106m"
readonly BGWHITE="\033[107m"

# Cursor style
readonly CURSOR_STYLE_BLOCK="\033[1 q"
readonly CURSOR_STYLE_VLINE="\033[3 q"
readonly CURSOR_STYLE_HLINE="\033[5 q"

# Cursor settings and movement
CURSOR_GET () {
    local pos

    stty -echo
    printf "\033[6n" > /dev/tty # returns \e[row;columnR
    IFS=" " read -d R pos
    stty echo

    # Remove ansi part
    pos="${pos:2}"

    # Print row and col
    printf "${pos%;*} ${pos#*;}"
}

readonly CURSOR_SAVE="\033[s"
readonly CURSOR_LOAD="\033[u"
readonly CURSOR_SHOW="\033[?25h"
readonly CURSOR_HIDE="\033[?25l"
readonly CURSOR_UP="\033[1A"
readonly CURSOR_DOWN="\033[1B"
readonly CURSOR_FORWARD="\033[1C"
readonly CURSOR_BACK="\033[1D"
readonly CURSOR_NEXTLINE="\033[1E"
readonly CURSOR_PREVLINE="\033[1F"

# Cursor absolute position (default to 1)
# Usage: [horizontal position]
CURSOR_HORIZONTAL () { [[ "${1:-1}" -gt 0 ]] && printf "\033[$1G"; }
# Usage: [row] [column]
CURSOR_POSITION () { [[ "${1:-1}" -gt 0 && "${2:-1}" -gt 0 ]] && printf "\033[$1;$2H"; }

# Erase characters (from cursor position)
readonly ERASE_DISPLAY_END="\033[0J"
readonly ERASE_DISPLAY_BEGIN="\033[1J"
readonly ERASE_DISPLAY="\033[2J"
readonly ERASE_DISPLAY_BUFFER="\033[3J"
readonly ERASE_LINE_END="\033[0K"
readonly ERASE_LINE_BEGIN="\033[1K"
readonly ERASE_LINE="\033[2K"

# Scroll display buffer
readonly SCROLL_UP="\033[1S"
readonly SCROLL_DOWN="\033[1T"

# 256 color support
VGACOLOR () { [[ $1 -ge 0 && $1 -lt 256 ]] && printf "\033[38;5;$1m"; }

# 24 bit color support
# Usage: (BG|TERM)RGBCOLOR <24 bit hex color code>
RGBCOLOR () {
    [[ "$1" =~ ^[0-9a-fA-F]{6}$ ]] && printf "\033[38;2;$((16#${1:0:2}));$((16#${1:2:2}));$((16#${1:4:2}))m"
}
BGRGBCOLOR () {
    [[ "$1" =~ ^[0-9a-fA-F]{6}$ ]] && printf "\033[48;2;$((16#${1:0:2}));$((16#${1:2:2}));$((16#${1:4:2}))m"
}
TERMRGBCOLOR () { printf "\e]11;#$1\a"; }

# For terminals with hyperlink support
# Usage: <link> <text>
ANSI_HYPERLINK () { printf "\e]8;;$1\a$2\e]8;;\e\\"; }

# Unsure what these do, but they exist (let me know!)
# Usage: <text>
ANSI_GUARDED () { printf "\eV$1\eW"; }
ANSI_STRING () { printf "\eX$1\e\\"; }
ANSI_PRIVACY () { printf "\e^$1\e\\"; }
ANSI_APC () { printf "\e_$1\e\\"; }

