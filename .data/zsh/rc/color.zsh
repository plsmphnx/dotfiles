unalias ls
alias ls="ls --color -C"

[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
[[ -s "/usr/share/grc/grc.zsh" ]] && source /usr/share/grc/grc.zsh

man() { command man "$@" | bat -pl man ;}
help() { "$1" --help | bat -pl help ;}
