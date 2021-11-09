ZDOTDIR=~/.zsh

# plugin manager
[[ -f $ZDOTDIR/.zcomet/bin/zcomet.zsh ]] || \
    git clone https://github.com/agkozak/zcomet.git $ZDOTDIR/.zcomet/bin
source $ZDOTDIR/.zcomet/bin/zcomet.zsh

# history
HISTFILE=$ZDOTDIR/.history
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
ZSH_CACHE_DIR=$ZDOTDIR/.cache
[[ -d $ZSH_CACHE_DIR ]] || mkdir $ZSH_CACHE_DIR

# local paths
path=(. ~/.bin $path)

# right prompt
ZLE_RPROMPT_INDENT=0

# local config
for rc in ~/.zshrc.d/*.zsh(N); source $rc

# core plugins
zcomet load zsh-users/zsh-completions
zcomet compinit
zcomet load zsh-users/zsh-syntax-highlighting
