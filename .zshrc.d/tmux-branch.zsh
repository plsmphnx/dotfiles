precmd() {
    [[ -v TMUX ]] && print -n "\033k$(git rev-parse --abbrev-ref HEAD 2> /dev/null || print -nP %~)\033\\"
}
