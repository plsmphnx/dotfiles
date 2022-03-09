goto_ignore+=('.*')
goto() {
    local root=$(git rev-parse --show-toplevel 2> /dev/null || { pwd | cut -d/ -f-3 })
    local except=()
    for ignore in $goto_ignore; do
        except+=('-not' '-path' "*/$ignore")
    done
    cd $({ find $root -type d $except | fzf } || pwd)
    zle reset-prompt
}
zle -N goto{,}
bindkey "^\\" goto
