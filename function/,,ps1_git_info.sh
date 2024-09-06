,,ps1_git_info () {
    [[ -d .git ]] || return
    ,,have git || return
    local git_eng="env LANG=C git"

    # \[ and \] are passed as $1 and $2, so we can escape non-printables
    # Theoretically we could also use ${SYMBOL_GIT_BRANCH@P} to simply use \[ and \]
    local SYMBOL_GIT_BRANCH="${1}${PURPLE}${2}${1}${CYAN}${2}"
    local SYMBOL_GIT_TAG="${1}${DIMYELLOW}${2}tag${1}${CYAN}${2}"
    local SYMBOL_GIT_MODIFIED="${1}${RED}${2}*${1}${CYAN}${2}"
    local SYMBOL_GIT_PUSH="${1}${BLUE}${2}↑${1}${CYAN}${2}"
    local SYMBOL_GIT_PULL="${1}${GREEN}${2}↓${1}${CYAN}${2}"

    # get current branch name
    local ref tag
    ref="$($git_eng symbolic-ref --short HEAD 2>/dev/null)"
    tag="$($git_eng describe --tags --always 2>/dev/null)"

    [[ "$ref" ]] && ref="${SYMBOL_GIT_BRANCH}${ref}"
    [[ "$tag" ]] && tag="${SYMBOL_GIT_TAG}${tag}"

    [[ "$ref" ]] || ref="$tag"
    [[ "$ref" ]] || return

    # scan first two lines of output from `git status`
    local marks=""
    local line
    while IFS="" read -r line; do
        if [[ $line =~ ^## ]]; then # header line
            [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" ${SYMBOL_GIT_PUSH}${BASH_REMATCH[1]}"
            [[ $line =~ behind\ ([0-9]+) ]] && marks+=" ${SYMBOL_GIT_PULL}${BASH_REMATCH[1]}"
        else # branch is modified if output contains more lines after the header line
            marks="${SYMBOL_GIT_MODIFIED}${marks}"
            break
        fi
    done < <($git_eng status --porcelain --branch 2>/dev/null)

    printf " ${ref}${marks}"
}

