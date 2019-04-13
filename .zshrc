# plugin manager
declare -A ZPLGM
ZPLGM[HOME_DIR]=~/.zsh
ZPLGM[ZCOMPDUMP_PATH]=~/.zsh/completion
ZPLGM[COMPINIT_OPTS]="-i -d ${ZPLGM[ZCOMPDUMP_PATH]}"
[[ -d ${ZPLGM[HOME_DIR]} ]] || ZPLG_HOME=${ZPLGM[HOME_DIR]} \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
source "${ZPLGM[HOME_DIR]}/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# history
HISTFILE=~/.zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory histignoredups histreduceblanks histverify

# color aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# keybinds
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# working directory path
path+=(.)

# local config
for rc in ~/.zshrc.d/*.zsh(N); source $rc

# core plugins
zplugin light zsh-users/zsh-completions
zplugin ice atinit"zpcompinit; zpcdreplay"
zplugin light zsh-users/zsh-syntax-highlighting
