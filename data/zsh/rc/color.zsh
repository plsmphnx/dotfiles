alias diff="diff --color"
alias grep="grep --color"
alias less="less -R"
alias ls="ls --color -C"

(( $+commands[dircolors] )) && eval "$(dircolors -b)"

if (( $+commands[rgrc] )); then
    eval "$(rgrc --aliases --except diff,grep,journalctl,ls)"
    compdef rgrc=exec

    alias ls="rgrc ls --color -C"
fi

if (( $+commands[bat] )); then
    man() { command man "$@" | bat -pl man ;}
    help() { "$@" --help 2>&1 | bat -pl help ;}
    journalctl() { command journalctl "$@" | bat -pl syslog ;}

    compdef help=exec
fi

