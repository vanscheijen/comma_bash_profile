,news () {
    local f_usage="<string | file | stdin>"
    local f_info="Shows the news headlines via newsapi, optionally search all the news for given input"

    local data="$@"
    [[ -s "$data" ]] && data="$(< "$data")" || [[ "$data" ]] || data="$(,ifne cat)"

    [[ "$COMMA_NEWSAPI_KEY" ]] || { ,error "Environment variable COMMA_NEWSAPI_KEY is not set"; return 1; }

    local filter=".articles[] | \"$CYAN\" + .title + \" $RESET($RED\" + .source.name + \"$RESET)\", \"$DIMGRAY\" + .url, \"$RESET\" + .description, \"\""

    if [[ "$data" ]]; then
        curl "https://newsapi.org/v2/everything" -s -G \
            -d "q=$(,url_encode "$data")" \
            -d "apiKey=$COMMA_NEWSAPI_KEY" \
            | jq -r "${filter//\033/\u001b}"
    else
        curl "https://newsapi.org/v2/top-headlines" -s -G \
            -d "country=${COMMA_NEWSAPI_COUNTRY:-gb}" \
            -d "apiKey=$COMMA_NEWSAPI_KEY" \
            | jq -r "${filter//\033/\u001b}"
    fi
}

