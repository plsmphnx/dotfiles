precmd() {
    print "\033k$(git rev-parse --abbrev-ref HEAD 2> /dev/null || print -P %~)\033\\"
}
