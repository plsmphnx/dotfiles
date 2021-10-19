zinit ice src"gitstatus.prompt.zsh"
zinit light romkatv/gitstatus

setopt PROMPT_SUBST
RPROMPT='$([ $GITSTATUS_PROMPT_LEN -ne 0 ] && print " %(?.%F{black}%B<%b%f.%F{red}<%f) ")$GITSTATUS_PROMPT'
