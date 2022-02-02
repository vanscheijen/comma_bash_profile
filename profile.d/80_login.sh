# Login prompt

if shopt -q login_shell; then
    # NOTE: Complementary colors FFF100 and 6C0BC9
    ,echo "`RGBCOLOR FF5600`Comma `RGBCOLOR 00C786`.bash_profile${RESET} ${DIMGRAY}v${DIMCYAN}${COMMA_VERSION}${DIMGRAY}-${DIMGREEN}${COMMA_DATE_GENERATED}${RESET} ©2022 Fair License"
    ,box "`uname -a`"
    w
fi

