eval "$(rgrc --aliases --except diff,grep,journalctl,ls)"

alias diff="diff --color"
alias grep="grep --color"
alias less="less -R"
alias ls="rgrc ls --color -C"

man() { command man "$@" | bat -pl man ;}
help() { "$@" --help 2>&1 | bat -pl help ;}
journalctl() { command journalctl "$@" | bat -pl syslog ;}

compdef help=exec
