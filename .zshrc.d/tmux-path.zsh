precmd() {
    [[ -v TMUX ]] && print -nP '\033k%~\033\\'
}
