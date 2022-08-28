unalias ls
alias ls="ls --color -C"

[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
[[ -s "/usr/share/grc/grc.zsh" ]] && source /usr/share/grc/grc.zsh
zcomet load ael-code/zsh-colored-man-pages

# grc env interferes with man
unset -f env
