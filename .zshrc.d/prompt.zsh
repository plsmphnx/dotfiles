setopt PROMPT_SUBST
prompt_dirname() {
    FULL=$(print -nP %~)
    NAME=$(dirname "$FULL")
    if [ "$NAME" != "." ]; then
        [ "$FULL" != "/" ] && print -n "$NAME"
        [ "$NAME" != "/" ] && print -n "/"
    fi
}
prompt_basename() {
    basename "$(print -nP %~)"
}
PROMPT='%F{cyan}$(prompt_dirname)%B$(prompt_basename)%b %(?.%F{white}>.%F{red}%B%?%b>)%F '
