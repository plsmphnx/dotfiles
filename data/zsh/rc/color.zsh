alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias less="less -R"
alias ls="ls --color -C"

[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
[[ -s "/usr/share/grc/grc.zsh" ]] && source /usr/share/grc/grc.zsh

man() { command man "$@" | bat -pl man ;}
help() { "$@" --help | bat -pl help ;}
journalctl() { command journalctl "$@" | bat -pl syslog ;}

compdef help=exec
