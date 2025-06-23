GITSTATUS_CACHE_DIR=$ZSH_CACHE_DIR/gitstatus
zcomet load romkatv/gitstatus gitstatus.prompt.zsh

setopt PROMPT_SUBST
RPROMPT='$([ $GITSTATUS_PROMPT_LEN -ne 0 ] && print " %(?.%F{black}%B<%b%f.%F{red}<%f) ")$GITSTATUS_PROMPT'
