unalias ls
alias ls="ls --color -C"

[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
zinit light ael-code/zsh-colored-man-pages

# grc env interferes with man
unset -f env
