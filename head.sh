#!/bin/bash
## Comma .bash_profile | https://github.com/vanscheijen/comma_bash_profile
## ©2012-2023 vanScheijen
## Usage of the works is permitted provided that this instrument is retained with the works, so that any entity that uses the works is notified of this instrument.
## DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

if ((BASH_VERSINFO[0] < 3)); then
    echo "ERROR: You need bash-3.0 or higher for the Comma .bash_profile"
    return 30
fi

if [[ "$COMMA_VERSION" ]]; then
    ,ok "$(RGBCOLOR FF5600)Comma $(RGBCOLOR 00C786).bash_profile ${DIMGRAY}v${DIMCYAN}${COMMA_VERSION}${DIMGRAY}-${DIMGREEN}${COMMA_DATE_GENERATED}${RESET} already loaded"
    return 0
fi

