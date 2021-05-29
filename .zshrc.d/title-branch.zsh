title() { print -n "\e]0;$(git rev-parse --abbrev-ref HEAD 2> /dev/null || print -nP %~)\a" }
add-zsh-hook precmd title
add-zsh-hook preexec title
