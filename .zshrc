# plugin manager
declare -A ZINIT
ZINIT[HOME_DIR]=~/.zsh
ZINIT[ZCOMPDUMP_PATH]=~/.zsh/completion
ZINIT[COMPINIT_OPTS]="-i -d ${ZINIT[ZCOMPDUMP_PATH]}"
[[ -d ${ZINIT[HOME_DIR]} ]] || ZINIT_HOME=${ZINIT[HOME_DIR]} \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
source "${ZINIT[HOME_DIR]}/bin/zinit.zsh"

# history
HISTFILE=~/.zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory histignoredups histreduceblanks histverify

# color aliases
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias less="less -R"

# keybinds
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# cache
ZSH_CACHE_DIR=~/.zsh/cache
[[ -d $ZSH_CACHE_DIR ]] || mkdir $ZSH_CACHE_DIR

# local paths
path+=(~/.bin .)

# right prompt
ZLE_RPROMPT_INDENT=0

# local config
for rc in ~/.zshrc.d/*.zsh(N); source $rc

# core plugins
zinit light zsh-users/zsh-completions
zinit ice wait lucid atinit'zpcompinit;zpcdreplay'
zinit light zdharma/fast-syntax-highlighting
