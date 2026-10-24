source $ZSH_PLUGIN_DIR/gitstatus/gitstatus.prompt.zsh
setopt promptsubst
RPROMPT='$([ $GITSTATUS_PROMPT_LEN -ne 0 ] && print " %(?.%F{black}%B<%b%f.%F{red}<%f) ")$GITSTATUS_PROMPT'
