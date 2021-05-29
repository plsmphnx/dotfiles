title() { print -nP '\e]0;%~\a' }
add-zsh-hook precmd title
add-zsh-hook preexec title
