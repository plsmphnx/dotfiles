ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
declare -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
    [redirection]='none'
    [path_prefix]='none'

    [single-hyphen-option]='fg=cyan'
    [double-hyphen-option]='fg=cyan'

    [autodirectory]='fg=green'
    [precommand]='fg=green'
    [suffix-alias]='fg=green'

    [path]='fg=magenta,bold'
    [globbing]='fg=blue,bold'
    [history-expansion]='fg=blue,bold'
)
